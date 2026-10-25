# Project state — Owen-125B

Updated: 2026-10-25

## Stage

`IMPLEMENTATION — deployment prototype prepared; GPU trial not yet run`

## Objective

Keep a reproducible, separate deployment for the 125B Qwen3.8-Flash-Next model with Strata on an on-demand GPU pod, plus a safe OpenAI-compatible API connection from the Mac.

## Current choices

- Runtime: Strata source setup, pinned to release `v0.2.5` pending live compatibility test.
- Checkpoint: `alesha-pro/Qwen3.8-Flash-Next-abliterated-GSQ-RCO-Strata-GGUF`, `IQ2_XS` (smallest tested uncensored option with image projector).
- Trial host recommendation: RunPod RTX 3090, 24 GB VRAM, 125 GB RAM, catalog price $0.50/h before storage; select only if checkout confirms all requirements and total remains under $1/h.
- Model weights will be downloaded to ephemeral local disk each new pod; no persistent volume configured.
- API is loopback-only on the pod and reached through an SSH tunnel; no public API port.

## Active work

- Deployment scripts and operator documentation.

## Not yet verified

- Fresh RunPod pod end-to-end install and model startup.
- Actual price/availability in the RunPod checkout.
- Throughput, image input, and Cline compatibility.

## Next checkpoint

Review scripts; publish to the existing GitHub repository; then run the bounded GPU trial on a confirmed eligible pod.
