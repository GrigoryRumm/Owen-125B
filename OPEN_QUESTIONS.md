# Open questions — Owen-125B

| ID | Priority | Question | Recommendation | Blocks |
| --- | --- | --- | --- | --- |
| Q-001 | P0 | Is the eligible RunPod RTX 3090 pod actually available, and is total hourly cost (compute + any storage) <= $1? | Verify the exact live checkout; do not substitute if over budget. | Creating paid pod |
| Q-002 | P1 | Does the pinned Strata source setup accept this model card's custom model and projection flags unchanged? | Confirm on the first trial; adjust only after checking release docs. | First successful deployment |
| Q-003 | P1 | What exact model ID and key behavior does this Strata setup expose to Cline? | Read from `/v1/models` and Strata startup output, then update README. | Client connection |
| Q-004 | P2 | What throughput and image quality do we measure on the selected host? | Run text + image smoke tests and record actual results. | Performance claims |
