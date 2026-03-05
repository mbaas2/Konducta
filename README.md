# Konducata

Event-driven automation framework written in Dyalog APL.

![Konducta Logo](./konducta.svg)

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

Konducata supports modular handler loading. Configure handler repositories in `Config/konducata.json5`:

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
