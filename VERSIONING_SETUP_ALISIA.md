# Versionierung für Konducta-Alisia einrichten

## Dateien erstellen (in c:\Git\Konducta-Alisia\)

### 1. VERSION
```
1.0.0
```

### 2. APLSource/Version.aplf
```apl
 Version←{
⍝ Returns Konducta-Alisia handler version from VERSION file
⍝ In development: appends -dev+SHA (e.g., "1.0.0-dev+a3f5c2b")
⍝ On tagged release: clean version (e.g., "1.0.0")
⍝ ⍵: optional path to handler root (default: current directory)
     path←{0=⎕NC'⍵':'' ⋄ ⍵}⍵
     vfile←path,'VERSION'
     :If ⎕NEXISTS vfile
         base←⊃⎕NGET vfile 1
         ⍝ Check if we're on a tagged release
         :Trap 0
             tag←⊃⎕SH'cd "',path,'" && git describe --exact-match --tags 2>nul'
             :If 0<≢tag
                 :Return base  ⍝ On tag: return clean version
             :EndIf
         :EndTrap
         ⍝ Development: append git SHA
         :Trap 0
             sha←⊃⎕SH'cd "',path,'" && git rev-parse --short HEAD 2>nul'
             :If 0<≢sha
                 base,'-dev+',sha
             :Else
                 base
             :EndIf
         :Else
             base
         :EndTrap
     :Else
         'unknown'
     :EndIf
 }
```

### 3. CHANGELOG.md
```markdown
# Changelog

All notable changes to Konducta-Alisia will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-05

### Added
- Initial release as separate handler repository
- Version tracking with VERSION file and Version.aplf
- Flat APLSource structure

### Changed
- Extracted from Konducta core repository
- Now loaded via `handlerRepos` configuration

## [0.x.x] - Historic
- Part of Konducta/Eventler monolithic structure
```

### 4. README.md Update
Füge nach dem Titel hinzu:
```markdown
**Current Version:** 1.0.0 ([CHANGELOG](CHANGELOG.md))
```

Füge am Ende hinzu:
```markdown
## Versioning

This handler follows [Semantic Versioning](https://semver.org/).

- `VERSION` file - Current version
- `Version.aplf` - APL function to read version
- `CHANGELOG.md` - Release notes

See main [Konducta repository](https://github.com/your-org/Konducta) for versioning guidelines.
```

## Git Commands

```powershell
cd c:\Git\Konducta-Alisia
git add VERSION CHANGELOG.md APLSource/Version.aplf README.md
git commit -m "Add version tracking: VERSION file, Version.aplf, CHANGELOG.md (v1.0.0)"
git tag -a v1.0.0 -m "Release v1.0.0: Initial standalone release"
```
