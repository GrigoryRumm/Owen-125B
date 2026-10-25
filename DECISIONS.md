# Decisions — Owen-125B

| ID | Date | Decision | Status | Evidence |
| --- | --- | --- | --- | --- |
| ADR-001 | 2026-10-25 | Use RunPod NVIDIA RTX 3090 24 GB / 125 GB RAM as the first trial candidate, only if live checkout confirms <=$1/h before any separately priced storage. Do not use a 16 GB host with inadequate RAM. | Accepted for trial | RunPod public Pods price table lists the RTX 3090 config at $0.50/h; Strata/model requirements rely heavily on host RAM. |
| ADR-002 | 2026-10-25 | Use Qwen3.8-Flash-Next abliterated GSQ-RCO IQ2_XS with Strata control vector and vision projector. | Accepted for trial | Published model card lists 68 GB download, ~35.5 GB expert RAM, 12 GB+ GPU; IQ2_XS is the lightest measured variant. |
| ADR-003 | 2026-10-25 | Keep API on pod loopback and connect only through SSH local port-forward. | Accepted | Avoids exposing an unauthenticated inference API. |
| ADR-004 | 2026-10-25 | Use ephemeral local pod disk; re-download model on a newly created pod; avoid recurring storage in v1. | Accepted | Owner prefers downloading the model again; avoids idle volume charges, subject to actual provider billing details. |
| ADR-005 | 2026-10-25 | Pin Strata source to release v0.2.5 and model files to HF revision 9ac6e29 for the trial. | Provisional | Latest official Strata release page and verified HF model-card revision at time of research. |
