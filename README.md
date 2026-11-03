# 🚂 Rakazo → Railway: Hello World Lifecycle

> 🤖 Written by the **Railway Usage Manager** bot on Rakazo, for Rifat Erdem Sahin.
> 📅 Run date: **Tuesday 3 November 2026**, 23:07–23:33 UTC.
> 🎯 Goal: prove the round trip from *a chat message in Rakazo* to *a verified, publicly reachable app on Railway*.

---

## ✅ Result first

| 🔎 Check | 📊 Value |
| --- | --- |
| 🌍 Live URL | **https://hello-world-app-production-a689.up.railway.app** |
| 💬 Response body | `Hello World from Railway` |
| 📡 HTTP status | **200 OK** |
| 🟢 Deployment status | **SUCCESS** (deployment `7109976c`, 23:12:21 UTC) |
| 📦 Image | `hashicorp/http-echo:1.0` |
| 🎛️ Start command | `/http-echo -text="Hello World from Railway" -listen=:8080` |
| 🗺️ Region | `sfo`, 1 replica |
| 🔁 Restart policy | `ON_FAILURE`, max 10 retries |
| 💤 Sleep when idle | ❌ disabled (always on → always metered) |
| 💾 Volumes | none |

---

## 🏗️ What exists on Railway now

**Project** `cheerful-purpose` — id `5702f8c4-a19b-4ff9-a2e4-79edf604e2f0`
**Environment** `production` — id `5330fd0b-b8b4-4aa8-bc48-8724cf008099` (created 23:07:05 UTC)
**Workspace** "Rifat Erdem Sahin's Projects"

| # | 🧩 Service | 🆔 Service ID | 🖼️ Image | 📌 State |
| --- | --- | --- | --- | --- |
| 1 | `hello-world-app` | `a2072ffe-91d6-4c29-a645-e6fa3ee22009` | `hashicorp/http-echo:1.0` | ✅ SUCCESS — the one to use |
| 2 | `hello-world` | `aba31118-cbbf-41b6-8e97-f608c2fec9ae` | `nginxdemos/hello:plain-text` | ⚠️ SUCCESS but redundant (stock nginx text) — still billing |

> 🧹 Service 2 is a leftover from the first attempt. Delete it to stop the meter: it adds no value beyond service 1.

---

## 🕰️ Deployment timeline (absolute timestamps, UTC)

| ⏱️ Time | 🎬 Event | 🚦 Status |
| --- | --- | --- |
| 23:07:05 | 🆕 Project + `production` environment created | ✅ |
| 23:08:37 | 📦 First service deployed (`nginxdemos/hello:plain-text`) | ✅ SUCCESS |
| 23:10:16 | 🚀 First `http-echo` deploy attempt | 🗑️ REMOVED |
| 23:11:10 | 💥 `http-echo` deploy with malformed start command | ❌ FAILED |
| 23:12:21 | 🔧 Start command fixed to `/http-echo …` and redeployed | ✅ SUCCESS |
| 23:32 | 📈 Metrics sampled for idle CPU / memory | ℹ️ |

### 💥 Why the failure is worth keeping

The failed deployment had this start command:

```
-text="Hello World from Railway" -listen=:8080      ❌ no binary → container exits
```

Railway treats the start command as a shell line inside the image. Without the executable name the container starts nothing and the deploy fails. The fixed version prefixes the binary:

```
/http-echo -text="Hello World from Railway" -listen=:8080      ✅
```

That one-character-class fix (adding `/http-echo `) is the single most common cause of a *deploy* failure on image-backed Railway services — the build succeeds, the runtime dies.

---

## 📈 Measured cost profile (not estimated)

Sampled 3 Nov 2026 23:12–23:33 UTC from `RAILWAY_GET_RESOURCE_METRICS`:

- 🧠 **Memory**: ~0.0070–0.0118 GB (**≈ 7–12 MB**) — an http-echo process is essentially free.
- ⚙️ **CPU**: ~5×10⁻⁷ to 5×10⁻⁵ vCPU at idle — effectively zero.
- 💾 **Disk / volumes**: none attached.
- 💤 **Sleep**: disabled, so the container holds a resident slice 24/7.

**Plan context**: Railway **Pro**, $20/month base plus usage. The receipt dated 2 Nov 2026 was **$24.00 including VAT with $0.00 metered usage**. Two tiny always-on containers land in small change, but they are metered every hour of every day — so the honest number is "low, but not zero".

---

## 🔄 The lifecycle: Rakazo message → live Railway app

Each stage is where control actually changes hands. 🧠 = model reasoning, 🔌 = connected tool, ☁️ = Railway.

```
👤 User: "create a hello world app on railway"
        │
        ▼
🧠 1. INTENT ── Rakazo agent parses the ask, decides Railway is the target
        │
        ▼
🔌 2. CAPABILITY ── Composio Railway connector, OAuth as info@pexabo.com
        │            (connected 3 Nov 2026 22:53 UTC)
        ▼
🛡️ 3. PERMISSION ── per-tool approval cards; every spend-mutating call
        │            (create service, create domain, deploy) approved 1×
        ▼
🔑 4. SCOPE ── project/write calls need a workspace_id; the account user ID
        │       is rejected ("Not Authorized") and the dashboard hides the UUID
        ▼
☁️ 5. PROJECT ── project created in the browser dashboard (only path that
        │          worked), which auto-creates env `production`
        ▼
☁️ 6. SERVICE ── image-backed service + deploy settings sent via connector:
        │          image, start command, region, replicas, restart policy
        ▼
☁️ 7. DEPLOY ── Railway pulls the image and walks the state machine:
        │          INITIALIZING → BUILDING → DEPLOYING → SUCCESS | FAILED
        ├── ❌ FAILED → 🧠 read the deployment manifest → fix start command → redeploy
        ▼
☁️ 8. NETWORK ── domain generated on the Railway edge, TLS issued,
        │          edge :443 → container :8080
        ▼
🔌 9. VERIFY ── HTTP GET from outside returns 200 + expected body
        │        (never trust SUCCESS alone; assert the body)
        ▼
📈 10. OBSERVE ── metrics scraped (CPU, memory, network), usage metered to
        │         the invoice, limits watched for the next check
        ▼
👤 User: sees a live URL and a measured cost line
```

### 🧭 Stage-by-stage in words

1. **🧠 Intent** — the request arrives as natural language, not a pipeline trigger. The agent decides *what* to build and *where*: an image-backed stateless service on Railway.
2. **🔌 Capability** — a plugin layer exposes Railway operations as typed tools. No credentials live in the chat; the connection is an OAuth grant held by the connector.
3. **🛡️ Permission** — anything that creates resources or spend is gated behind an explicit approval card. Read-only discovery runs freely; writes wait for the human.
4. **🔑 Scope resolution** — this is where agent-driven cloud work usually stalls: Railway needs a `workspace_id`, not a user id. Falling back to the dashboard for project creation, then returning to the API for service-level work, is the pragmatic detour.
5. **☁️ Project creation** — creates the project *and* the `production` environment in one step. The environment is the deploy target for everything after.
6. **☁️ Service definition** — image, command, region, replica count, restart policy. All declarative; no Dockerfile and no build step for a prebuilt image.
7. **☁️ Deployment execution** — Railway's asynchronous state machine. The interesting states are `FAILED` (build or runtime died) and `REMOVED` (superseded). Read `meta.serviceManifest` on the deployment to see exactly what the platform executed — that is how the bad start command was diagnosed.
8. **☁️ Networking** — a generated domain plus managed TLS; the edge maps 443 to the container's listening port. This is why `-listen=:8080` must match the service's public port.
9. **🔌 Verification** — hitting the URL from outside the platform. Status alone is insufficient: assert the response body matches what you intended.
10. **📈 Observability & billing** — metrics and metered usage feed the invoice. For an agent managing spend, the loop closes here: measure, compare against limits, flag early.

---

## 🔁 Reproduce it

```bash
# 1. put a hello world on Railway (dashboard or CLI)
railway init --name cheerful-purpose

# 2. deploy a prebuilt echo image with an explicit binary path
#    in the dashboard: New → Deploy from image
#    image: hashicorp/http-echo:1.0
#    start:  /http-echo -text="Hello World from Railway" -listen=:8080

# 3. expose port 8080 and generate a domain

# 4. assert the body, not just the status
curl -fsS https://hello-world-app-production-a689.up.railway.app
# → Hello World from Railway
```

Or run the bundled check: `./verify.sh <url>`

---

## ⚠️ Known sharp edges

- 🧩 **No workspace-listing tool** in the connector — you must bring a `workspace_id` yourself.
- 🌐 **Project creation via API was refused** for this account; the dashboard was the working path.
- 💸 **Two services are running**, one of them redundant. Each always-on replica bills hourly.
- 🛰️ **TLS + domain are free; egress is not.** Network bytes are metered on the same invoice.
- 🤖 **Self-hosting Rakazo here would need a remote sandbox provider** (E2B, Daytona, CreateOS or Boat) — Railway cannot pass a Docker socket to a sandbox supervisor, so bots hosted there would have no computer.

---

## 📚 References in this repo

- `verify.sh` — asserts HTTP 200 **and** the expected body from an external viewpoint.
- `railway.json` — config-as-code skeleton for an image-backed service (illustrative template).
- `docs/lifecycle.md` — the same lifecycle as a compact checklist for reuse.
