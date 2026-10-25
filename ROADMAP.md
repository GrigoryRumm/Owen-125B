# Roadmap — Owen-125B

1. Prepare requirements, architecture, cost/safety boundaries, and deployment scripts. **Current.**
2. Review local changes, shell-test the script, and publish to the existing GitHub repository.
3. Confirm live RunPod offer and full price stays within owner's limit; provision only the selected temporary pod.
4. Install/download with `scripts/deploy.sh`; verify text API and vision on the actual pod.
5. Set up Cline using the verified URL/model ID/key and a local SSH tunnel; document verified settings.
6. Stop the pod, confirm compute is no longer billed, and inspect any retained storage.

Do not progress to a more expensive resource, persistent volume, public API, or additional integration without a fresh owner decision.
