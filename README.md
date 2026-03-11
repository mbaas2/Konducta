# Konducta

Event-driven automation framework written in Dyalog APL.

![Konducta Logo](./konducta.svg)

**Current Version:** 1.0.0 ([CHANGELOG](CHANGELOG.md))

Konducta monitors event sources (e.g. email via POP3), evaluates a rule set, and
dispatches events to handler applications. It provides the runtime, rule engine,
Jarvis web server integration, and the `KonductaHandler` base class that all
handlers inherit from.

## Architecture

```text
Konducta (this repo)          Handler repos (pluggable)
─────────────────────          ─────────────────────────
Run.aplf                       Konducta-Alisia/APLSource/alisia.aplc
procEvents.aplf         ←─→    Konducta-GitHub/APLSource/GitHubHandler.aplc
applyRule.aplf                 ... (any custom handler)
KonductaHandler.aplc
LoadHandlerRepos.aplf
ResolveHandler.aplf
Triggers/email/email.aplc
Jarvis.dyalog

        APLde-Konducta (config repo)
        ─────────────────────────────
        Config/Konducta.json5       ← handlerRepos configuration
        Config/triggers.json5        ← handler references
        Config/rules.json5
```

## Environment Variables

- `Konducta_ROOT`: Root directory (contains Config/, Data/, HTML/)
- `KonductaConfig`: Optional config directory override (contains `Konducta.json5`, `triggers.json5`, `rules.json5`)
- `KONDUCTA_CONFIG`: Alias for `KonductaConfig` (same behavior)

## Remote Secret Update (MVP)

Konducta includes a lightweight Jarvis workflow to update production secrets without shell/RDP access to the server.

Endpoint:

- `POST /secret_update` (stage update)
- `POST /secret_update_confirm` (activate staged update)

Auth:

- Configure `secret_update_token` in `$Konducta_ROOT/Config/Konducta.json5`.
- Send the token in JSON body as `token`.

Step 1 request body (`/secret_update`):

```json
{
  "token": "<secret_update_token>",
  "secrets": {
    "Alisia_dev": {
      "smtp_pswd": "new-smtp-password",
      "pop3_pswd": "new-pop3-password"
    }
  }
}
```

After step 1, Konducta sends a confirmation mail to `secret_update_confirm_to`.
That mail contains a confirmation code.

Step 2 request body (`/secret_update_confirm`):

```json
{
  "code": "<confirmation code from email>"
}
```

PowerShell example:

```powershell
$body = @{
  token   = "CHANGE-ME-LONG-RANDOM-TOKEN"
  secrets = @{
    Alisia_dev = @{
      smtp_pswd = "new-smtp-password"
      pop3_pswd = "new-pop3-password"
    }
  }
} | ConvertTo-Json -Depth 8

Invoke-RestMethod -Method Post -Uri "http://<host>:<port>/secret_update" -ContentType "application/json" -Body $body

# Then confirm with code from email:
$confirm = @{ code = "<confirmation code>" } | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri "http://<host>:<port>/secret_update_confirm" -ContentType "application/json" -Body $confirm
```

Behavior:

- `/secret_update` writes staged data to `$Konducta_ROOT/Config/secrets.pending.json5`.
- Secrets are activated only after `/secret_update_confirm`.
- After confirmation, secrets are written to `$Konducta_ROOT/Config/secrets.local.json5`.
- Runtime config is patched immediately after confirmation (no restart required).
- Konducta also hot-reloads this file in the main loop when modified.

Required config keys in `Konducta.json5`:

- `secret_update_token`
- `secret_update_confirm_to`
- `secret_update_smtp_server`
- `secret_update_smtp_port`
- `secret_update_smtp_secure`
- `secret_update_smtp_user`
- `secret_update_smtp_pswd`
- `secret_update_smtp_from`

Operational notes:

- Keep `secrets.local.json5` out of git.
- Protect Jarvis endpoint with network ACL/reverse proxy/IP allowlist.
- Rotate `secret_update_token` periodically.
- Do not log request payloads containing secrets.

## Handler Configuration

Konducta supports modular handler loading.
The runtime reads config files from `KonductaConfig` (or `KONDUCTA_CONFIG`) when set,
otherwise it falls back to `Config/` under `Konducta_ROOT`.
In practice, this file is usually maintained in the `APLde-Konducta` repo (deployment/config repo), not in this core repo.

Canonical location (without override):

- `$Konducta_ROOT/Config/Konducta.json5`

Template in this repo:

- `Config/Konducta.template.json5`

Example content:

```json5
{
  "version": "1.0",
  "handlerRepos": [
    {
      "name": "alisia",
      "path": "C:/Git/Konducta-Alisia/",
      "namespace": "#.Handlers.Alisia"
    },
    {
      "name": "github",
      "path": "C:/Git/Konducta-GitHub/",
      "namespace": "#.Handlers.GitHub"
    }
  ]
}
```

**Note:** All handler repos must have `APLSource/` structure. Use `⍎Env 'VAR_NAME'⍎` in path to reference environment variables via `readConfig`.

This repository does not track active deployment-specific `Config/*.json5` files.
It provides `Config/Konducta.template.json5` as a schema/example only.

Reference handlers in `Config/triggers.json5` using `"ClassName"` (legacy `"RepoName.ClassName"` is still accepted):

```json5
{
  "myMailTrigger": {
    "type": "email",
    "handler": "Alisia",
    "handler_cfg": {...}
  }
}
```

## Related Repos

- **Konducta-Alisia** — List server handler (pluggable via `handlerRepos`)
- **Konducta-GitHub** — GitHub webhook handler (pluggable via `handlerRepos`)
- **APLde-Konducta** — Deployment configuration for APL Germany
- **Custom handlers** — Any handler implementing `KonductaHandler` base class

## Versioning

This project follows [Semantic Versioning](https://semver.org/) (MAJOR.MINOR.PATCH).

**Version information:**

- `VERSION` file - Current version (plain text)
- `Version.aplf` - APL function to read version at runtime
  - On tagged release: returns clean version (e.g., `"1.0.0"`)
  - In development: appends git SHA (e.g., `"1.0.0-dev+a3f5c2b"`)
- `CHANGELOG.md` - Release history and notable changes
- Git tags - `v1.0.0` format for each release

**Creating a new release:**

1. Update `VERSION` file (e.g., `1.1.0`)
2. Document changes in `CHANGELOG.md`
3. Commit: `git commit -m "Release v1.1.0"`
4. Tag: `git tag -a v1.1.0 -m "Release v1.1.0: Description"`
5. Push: `git push && git push --tags`

**Version behavior:**

```apl
]load Konducta
Version ''                    ⍝ On tag v1.0.0:     "1.0.0"
                              ⍝ After 3 commits:   "1.0.0-dev+a3f5c2b"
                              ⍝ On tag v1.1.0:     "1.1.0"
```

Handler repositories (Konducta-Alisia, Konducta-GitHub) follow the same versioning scheme.
