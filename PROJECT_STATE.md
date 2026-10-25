# Project state — Owen-125B

Updated: 2026-10-25

## Stage

`LIVE TRIAL — Pod active; model loaded and text API verified; Cline/vision client checks pending`

## Objective

Keep a reproducible, separate deployment for the 125B Qwen3.8-Flash-Next model with Strata on an on-demand GPU pod, plus a safe OpenAI-compatible API connection from the Mac.

## Current choices

- Runtime: Strata source setup pinned to release `v0.2.5`; basic text API startup verified, with Cline and image tests pending.
- Checkpoint: `alesha-pro/Qwen3.8-Flash-Next-abliterated-GSQ-RCO-Strata-GGUF`, `IQ2_XS` (smallest tested uncensored option with image projector).
- Selected RunPod trial: RTX 3090, 24 GB VRAM, 125 GB catalog RAM, 32 vCPU; 120 GB ephemeral disk; checkout total $0.52/h ($0.50 GPU + $0.017 disk). Effective cgroup RAM observed from inside the Pod is about 116 GiB.
- Model weights will be downloaded to a 120 GB ephemeral container disk each new pod; no persistent volume configured.
- Model `alesha-pro/Qwen3.8-Flash-Next-abliterated-GSQ-RCO-Strata-GGUF`, `IQ2_XS`, pinned revision `9ac6e29`; Strata `v0.2.5`, context `131072`, images enabled, experimental refusal-direction projection enabled.
- OpenAI-compatible Model ID: `qwen3.8-flash-next-iq2_xs`. API on pod loopback `127.0.0.1:8080`; SSH tunnel to Mac is active; no public API port.

## Verified

- Model files passed the publisher SHA-256 manifest check.
- `GET /v1/models` through the Mac tunnel reports the expected model, context 131072, and input modalities `text,image`.
- A short OpenAI-compatible chat completion returned `READY` using API key value `qwen-local`.
- Deployment code pushed to GitHub `main` through commit `559cee4`. This file records the observed trial runtime; public docs avoid Pod IDs, public IPs, and SSH key paths.

## Pending

- Cline configuration and a text request from Cline.
- An actual image prompt, throughput, and stability on a long request.
- Confirm stop behavior and storage/billing behavior in RunPod before ending the trial.

## Next checkpoint

Configure Cline with the verified local tunnel endpoint and model ID, run a short text and image prompt, then stop the Pod in RunPod when finished. Keep all usage under the owner's $1/h limit.
