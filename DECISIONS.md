# Decisions — Owen-125B

| ID | Date | Decision | Status | Evidence |
| --- | --- | --- | --- | --- |
| ADR-001 | 2026-10-25 | Use the available RunPod RTX 3090, 24 GB VRAM / 62 GB RAM / 32 vCPU, with 120 GB ephemeral container disk, as the first trial candidate. | Accepted for trial; not deployed | Live checkout shows $0.50/h GPU + $0.017/h container disk = $0.52/h total. This is below the $1/h cap and the host RAM exceeds the model card's 48 GB IQ2_XS recommendation. |
| ADR-002 | 2026-10-25 | Use Qwen3.8-Flash-Next abliterated GSQ-RCO IQ2_XS with Strata control vector and vision projector. | Accepted for trial | Published model card lists 68 GB download, ~35.5 GB expert RAM, 12 GB+ GPU; IQ2_XS is the lightest measured variant. |
| ADR-003 | 2026-10-25 | Keep API on pod loopback and connect only through SSH local port-forward. | Accepted | Avoids exposing an unauthenticated inference API. |
| ADR-004 | 2026-10-25 | Use ephemeral local pod disk; re-download model on a newly created pod; avoid recurring storage in v1. | Accepted | Owner prefers downloading the model again; avoids idle volume charges, subject to actual provider billing details. |
| ADR-005 | 2026-10-25 | Pin Strata source to release v0.2.5 and model files to HF revision 9ac6e29 for the trial. | Provisional | Latest official Strata release page and verified HF model-card revision at time of research. |
