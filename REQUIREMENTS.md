# Requirements — Owen-125B

## Goal

Deploy Qwen3.8-Flash-Next 125B (MoE) using the Strata runtime and an abliterated/uncensored IQ2_XS GGUF on an on-demand GPU pod. Provide an OpenAI-compatible endpoint for a Mac client and preserve all deployment source in this GitHub repository.

## In scope

- Reproducible one-command bootstrap after a compatible Linux GPU pod is provisioned and accessed over SSH.
- NVIDIA CUDA, Strata, model download, vision projector, and refusal-direction projection setup.
- Local-only API plus SSH port-forward instructions.
- Explicit stop/shutdown guidance to limit compute and storage charges.

## Out of scope

- Automatically creating, deleting, or paying for cloud resources from an unattended script.
- Publicly exposing the model API, allowing unauthenticated network access, or enabling agent tools on the GPU host.
- Guaranteeing uncensored behavior, model accuracy, throughput, or support for harmful activity.

## Acceptance criteria

- `scripts/deploy.sh` refuses hosts lacking NVIDIA GPU, at least 12 GB VRAM, 64 GB RAM, or 110 GB free disk.
- It downloads pinned model files, verifies supplied checksums where available, and configures Strata with vision plus the refusal-direction control vector.
- API remains bound to loopback; no API/token is committed.
- README explains RunPod selection, price ceiling, SSH forwarding, client settings, test, and how to stop both model and pod.
- Shell syntax and static checks pass. First live inference test remains an explicit milestone.

## Constraints

- RunPod compute price must be no more than $1/hour; storage, taxes, and network charges must also be reviewed before creation.
- Prefer RunPod RTX 3090 24 GB VRAM / 125 GB RAM at displayed $0.50/hour only if those specs and price appear in the actual checkout. Do not silently substitute a different priced configuration.
- No secrets in Git. No persistent model volume in the initial prototype.
- Only user-authorized project/model content may be used; model card terms apply.
- All model/engine setup is user-level where possible; never grant the model root or host automation privileges.
