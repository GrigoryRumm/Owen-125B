#!/usr/bin/env bash
set -Eeuo pipefail

# First-release trial: RunPod Linux + NVIDIA, Strata v0.2.5 and the pinned
# public Hugging Face revision. No public API port is opened by this script.

readonly STRATA_TAG="v0.2.5"
readonly MODEL_REPO="alesha-pro/Qwen3.8-Flash-Next-abliterated-GSQ-RCO-Strata-GGUF"
readonly MODEL_REVISION="9ac6e29"
readonly TIER="IQ2_XS"
readonly WORK_ROOT="${OWEN_WORK_ROOT:-${TMPDIR:-/tmp}/owen-runtime}"
readonly MODEL_DIR="$WORK_ROOT/model"
readonly STRATA_DIR="$WORK_ROOT/Strata"
readonly TIER_DIR="$MODEL_DIR/$TIER"
readonly VENV_DIR="$WORK_ROOT/.venv"

die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
info() { printf '\n==> %s\n' "$*"; }

[[ "$(uname -s)" == Linux ]] || die "Run this on the rented Linux GPU pod, not on your Mac."
command -v git >/dev/null || die "git is required. Use an NVIDIA CUDA Linux image with git installed."
command -v nvidia-smi >/dev/null || die "NVIDIA driver/GPU not found. Select an NVIDIA pod."
command -v python3 >/dev/null || die "python3 is required."
command -v curl >/dev/null || die "curl is required."

gpu_mib="$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | sort -nr | head -n1 | tr -d ' ')"
(( gpu_mib >= 12000 )) || die "Need at least 12 GB VRAM; detected ${gpu_mib} MiB."
# /proc/meminfo may show host RAM instead of the container's usable limit.
ram_kib="$(awk '/MemTotal:/ {print $2}' /proc/meminfo)"
for limit_file in /sys/fs/cgroup/memory.max /sys/fs/cgroup/memory/memory.limit_in_bytes; do
  if [[ -r "$limit_file" ]]; then
    limit_bytes="$(<"$limit_file")"
    if [[ "$limit_bytes" =~ ^[0-9]+$ ]] && (( limit_bytes < 1152921504606846976 )); then
      limit_kib=$((limit_bytes / 1024))
      (( limit_kib < ram_kib )) && ram_kib="$limit_kib"
    fi
    break
  fi
done
(( ram_kib >= 48 * 1024 * 1024 )) || die "Need at least 48 GiB system RAM for IQ2_XS; detected about $((ram_kib / 1024 / 1024)) GiB."
mkdir -p "$WORK_ROOT"
free_kib="$(df -Pk "$WORK_ROOT" | awk 'NR==2 {print $4}')"
(( free_kib >= 90 * 1024 * 1024 )) || die "Need at least 90 GiB free disk at $WORK_ROOT; choose a larger ephemeral disk."

info "Hardware accepted: $(nvidia-smi --query-gpu=name,memory.total --format=csv,noheader | head -n1), effective cgroup/host limit $((ram_kib / 1024 / 1024)) GiB RAM."
info "Installing the Hugging Face download client in an isolated virtual environment."
if [[ ! -x "$VENV_DIR/bin/python" ]] || ! "$VENV_DIR/bin/python" -m pip --version >/dev/null 2>&1; then
  python3 -m venv "$VENV_DIR" || die "Could not create a Python virtual environment. Install python3-venv and retry."
fi
"$VENV_DIR/bin/python" -m pip install --upgrade pip huggingface_hub
export PATH="$VENV_DIR/bin:$PATH"
command -v hf >/dev/null || die "The hf command was not installed. Reconnect to the pod shell and retry."

info "Downloading pinned IQ2_XS model, vision projector, refusal-direction vector, and checksums. This is about 70 GB."
mkdir -p "$TIER_DIR"
hf download "$MODEL_REPO" \
  "$TIER/Qwen3.8-Flash-Next-GSQ-RCO-IQ2_XS-00001-of-00002.gguf" \
  "$TIER/Qwen3.8-Flash-Next-GSQ-RCO-IQ2_XS-00002-of-00002.gguf" \
  "mmproj-Qwen3.8-Flash-Next-BF16.gguf" \
  "Huihui-Qwen3.8-Flash-Next-refusal-direction-r.gguf" \
  "SHA256SUMS" \
  --revision "$MODEL_REVISION" --local-dir "$MODEL_DIR"

info "Verifying downloaded files against the publisher's SHA-256 manifest."
(cd "$MODEL_DIR" && sha256sum --check --ignore-missing SHA256SUMS)
mv -f "$MODEL_DIR/mmproj-Qwen3.8-Flash-Next-BF16.gguf" "$TIER_DIR/"

if [[ ! -d "$STRATA_DIR/.git" ]]; then
  info "Fetching Strata release $STRATA_TAG."
  git clone --depth 1 --branch "$STRATA_TAG" https://github.com/Niko1221/Strata.git "$STRATA_DIR"
fi

info "Preparing Strata and starting the local-only API. Review setup's summary before accepting downloads."
cd "$STRATA_DIR"
./setup.sh --setup \
  --model "$TIER" \
  --gguf-dir "$TIER_DIR" \
  --vision gpu \
  --experimental-speed-projection "$MODEL_DIR/Huihui-Qwen3.8-Flash-Next-refusal-direction-r.gguf"

cat <<'EOF'

Setup finished. Verify the server and API in Strata's output/log before connecting a client.
Expected API: http://127.0.0.1:8080/v1 (pod loopback only).
Do not expose port 8080 publicly. Use an SSH local port-forward from the Mac.
EOF
