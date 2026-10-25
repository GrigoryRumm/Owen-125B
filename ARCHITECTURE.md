# Architecture — Owen-125B

Status: `prototype; paid-host trial pending`

## Components

- GitHub repository: scripts, pinned source/model references, and operator instructions only.
- RunPod Linux pod: ephemeral workspace, Strata server, downloaded GGUF model and vision assets.
- MacBook: Cline or another OpenAI-compatible client; SSH local port-forward to the pod API.
- GPU model API: Strata HTTP API on pod loopback port 8080. The pod exposes SSH only; never publish port 8080.

## Data and trust boundaries

- The model and code downloaded from upstream are untrusted inputs; use the pinned references and published checksums, inspect logs, and do not run model-generated shell commands automatically.
- The API is reachable only through SSH forwarding. Do not switch Strata to LAN/cloud exposure for this first release.
- The deployment script installs dependencies and model/runtime files but does not execute model output or configure MCP/tools.
- Local model data lives on pod ephemeral disk. Stopping retains a pod's data according to provider behavior; deleting/recreating may require re-downloading ~80 GB.
- Cloud pod creation, ongoing storage, and shutdown are operator-controlled; this repository does not call the RunPod API.

## Deferred choices

- Persistent model volume: deferred to avoid recurring idle storage charges.
- Docker image: deferred; Strata's documented setup path is used first.
- API key: use only if required by the tested Strata mode; SSH tunnel is mandatory regardless.
- Higher-quality quantization: IQ3 variants need more RAM and/or VRAM; reconsider only after measuring IQ2_XS.
