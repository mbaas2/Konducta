# Konducata

Event-driven automation framework written in Dyalog APL.

![Konducta Logo](./konducta.svg)

**Current Version:** 1.0.0 ([CHANGELOG](CHANGELOG.md))

Konducata monitors event sources (e.g. email via POP3), evaluates a rule set, and
dispatches events to handler applications. It provides the runtime, rule engine,
Jarvis web server integration, and the `eventler_Handler` base class that all
handlers inherit from.

## Architecture

```text
Konducata (this repo)          Handler repos (pluggable)
─────────────────────          ─────────────────────────
Run.aplf                       Konducta-Alisia/APLSource/alisia.aplc
procEvents.aplf         ←─→    Konducta-GitHub/APLSource/GitHubHandler.aplc
applyRule.aplf                 ... (any custom handler)
eventler_Handler.aplc
LoadHandlerRepos.aplf
ResolveHandler.aplf
Triggers/email/email.aplc
Jarvis.dyalog

        APLde-Konducata (config repo)
        ─────────────────────────────
        Config/konducata.json5       ← handlerRepos configuration
        Config/triggers.json5        ← handler references
        Config/rules.json5
```

## Environment Variables

| Variable          | Description                                     |
|-------------------|-------------------------------------------------|
| `KONDUCATA_HOME`  | Root directory (contains Config/, Data/, HTML/) |

## Handler Configuration

Konducata supports modular handler loading.
The runtime reads `Config/konducata.json5` under `KONDUCATA_HOME`.
In practice, this file is usually maintained in the `APLde-Konducata` repo (deployment/config repo), not in this core repo.

Canonical location:

- `$KONDUCATA_HOME/Config/konducata.json5`

Template in this repo:

- `Config/konducata.template.json5`

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
It provides `Config/konducata.template.json5` as a schema/example only.

Reference handlers in `Config/triggers.json5` using `"RepoName.ClassName"`:

```json5
{
  "myMailTrigger": {
    "type": "email",
    "handler": "Alisia.alisia",
    "handler_cfg": {...}
  }
}
```

## Related Repos

- **Konducta-Alisia** — List server handler (pluggable via `handlerRepos`)
- **Konducta-GitHub** — GitHub webhook handler (pluggable via `handlerRepos`)
- **APLde-Konducata** — Deployment configuration for APL Germany
- **Custom handlers** — Any handler implementing `eventler_Handler` base class

## Versioning

This project follows [Semantic Versioning](https://semver.org/) (MAJOR.MINOR.PATCH).

**Version information:**
- `VERSION` file - Current version (plain text)
- `Version.aplf` - APL function to read version at runtime
- `CHANGELOG.md` - Release history and notable changes
- Git tags - `v1.0.0` format for each release

**Creating a new release:**

1. Update `VERSION` file (e.g., `1.1.0`)
2. Document changes in `CHANGELOG.md`
3. Commit: `git commit -m "Release v1.1.0"`
4. Tag: `git tag -a v1.1.0 -m "Release v1.1.0: Description"`
5. Push: `git push && git push --tags`

Handler repositories (Konducta-Alisia, Konducta-GitHub) follow the same versioning scheme.
