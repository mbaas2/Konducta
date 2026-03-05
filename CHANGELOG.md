# Changelog

All notable changes to Konducata will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-05

### Added
- Modular handler repository system (`handlerRepos` in config)
- `LoadHandlerRepos.aplf` - Dynamic handler loading from separate repos
- `ResolveHandler.aplf` - Handler namespace resolution
- `VERSION` file and `Version.aplf` for version tracking
- `Config/konducata.template.json5` - Configuration template
- Flat APLSource structure (removed Code/ subdirectory)

### Changed
- Renamed from "Eventler" to "Konducata"
- Handler repos must have `APLSource/` structure (not `APLSource/Code/`)
- Handlers referenced as `"RepoName.ClassName"` format
- Core files moved from `APLSource/Code/` to `APLSource/`

### Removed
- ALISIA_HOME environment variable (use `handlerRepos` config instead)
- Legacy `#.Code` namespace loading
- Handler-specific code (moved to separate repos: Konducta-Alisia, Konducta-GitHub)

## [0.x.x] - Historic (Eventler)
- Original implementation as "Eventler"
- Monolithic structure with handlers in Code/ subdirectory
