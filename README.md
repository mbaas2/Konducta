# Konducata

Event-driven automation framework written in Dyalog APL.

Konducata monitors event sources (e.g. email via POP3), evaluates a rule set, and
dispatches events to handler applications. It provides the runtime, rule engine,
Jarvis web server integration, and the `eventler_Handler` base class that all
handlers inherit from.

## Architecture

```
Konducata (this repo)          Alisia (handler repo)
─────────────────────          ─────────────────────
Run.aplf                       APLSource/Code/alisia.aplc
procEvents.aplf         ←─→   APLSource/Code/alisia_texts/
applyRule.aplf                 APLSource/Code/SMTP.dyalog
eventler_Handler.aplc          APLSource/Code/GitHub.apln
Triggers/email/email.aplc      HTML/
Jarvis.dyalog

        APLde-Konducata (config repo)
        ─────────────────────────────
        Config/eventler.json5
        Config/triggers.json5
        Config/rules.json5
        Config/alisia_styles.json5
```

## Environment Variables

| Variable          | Description                                      |
|-------------------|--------------------------------------------------|
| `KONDUCATA_HOME`  | Root directory (contains Config/, Data/, HTML/)  |
| `ALISIA_HOME`     | Root of the Alisia repo (optional; loads handler)|

## Related Repos

- **Alisia** — List server handler application
- **APLde-Konducata** — Deployment configuration for APL Germany
