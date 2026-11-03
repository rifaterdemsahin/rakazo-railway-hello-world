# 🔄 Rakazo → Railway lifecycle checklist

Reusable, platform-level sequence for taking a chat request to a verified Railway deployment.

## 🧠 1. Intent
- [ ] Identify target platform and workload shape (static, image, repo build, database).
- [ ] Decide statefulness: needs a volume or a plugin (Postgres, Redis)?

## 🔌 2. Capability
- [ ] Confirm the cloud connector is authenticated; note the account identity and the connection timestamp.
- [ ] Map the job to typed tools; do not shell out for what a connector tool covers.

## 🛡️ 3. Permission
- [ ] Anything creating resources or spend waits for explicit human approval.
- [ ] Read-only discovery runs first, to keep the approval card accurate.

## 🔑 4. Scope
- [ ] Resolve the workspace / project / environment IDs up front.
- [ ] If the API rejects your identifier, state the error and switch path deliberately (dashboard) rather than retrying.

## ☁️ 5. Project
- [ ] Create or select the project; note the environment it provisions.

## ☁️ 6. Service
- [ ] Choose source: repo build, Dockerfile, or prebuilt image.
- [ ] Set start command, region, replicas, restart policy, sleep policy.
- [ ] Attach volumes and variables before the first deploy where possible.

## ☁️ 7. Deploy
- [ ] Trigger the deployment, then watch the state machine to a terminal state.
- [ ] On `FAILED`, read the deployment manifest to see the executed command/config.
- [ ] Fix exactly one cause and redeploy; keep the failed deployment as evidence.

## 🌐 8. Network
- [ ] Confirm the container's listen port matches the public port.
- [ ] Generate a domain and let TLS issue; verify from outside the platform.

## 🔍 9. Verify
- [ ] Assert HTTP status **and** response body.
- [ ] Re-check after a redeploy — a new deployment can regress.

## 📈 10. Observe
- [ ] Sample CPU, memory, network, disk; record absolute timestamps.
- [ ] Compare metered usage against plan and limits; flag early.
- [ ] Remove superseded services so nothing idle-bills.
