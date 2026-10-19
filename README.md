# Daycast

**Plan your perfect week.** Daycast helps you pick a destination and compare how four activities—skiing, surfing, outdoor sightseeing, and indoor sightseeing—look over the **next seven days** using forecast-backed heuristics.

Native **iOS / SwiftUI** app. Data from [Open-Meteo](https://open-meteo.com/) (geocoding + forecast). No backend required.

## Features

1. **Destination search** — city/town search, recent destinations, debounced geocoding.
2. **Activity overview** — four activity cards with outlook score, suitable-day count, and reasons.
3. **Activity ranking** — seven days sorted by score with explanations.
4. **Daily detail** — sheet with conditions, factor breakdown, safety cautions, and activity disclaimers.

## Requirements

- Xcode 16+ (project targets recent iOS SDK)
- iOS Simulator or device

## Build & run

1. Clone the repository.
2. Open `Daycast.xcodeproj` in Xcode.
3. Select an iOS Simulator and press **⌘R**.

No API keys are required for Open-Meteo’s public endpoints.

## Tests

```text
⌘U  — run unit tests (DaycastTests) on a simulator
```

Core coverage includes scoring thresholds, ranking order/tie-breaks, forecast mapping, repository cache behavior, and view model load states.

## Architecture

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

| Layer | Role |
|-------|------|
| `Features/` | MVVM screens (Search, Overview, Ranking) |
| `Domain/` | Domain types, forecast availability |
| `Data/` | Repositories and DTO mapping |
| `Components/` + `Core/Theme/` | Design system |

## Scoring

Scores are **transparent heuristics**, not probabilities. Thresholds, ranking rules, and limitations: [docs/SCORING.md](docs/SCORING.md).

## Decisions & scope

[docs/DECISIONS.md](docs/DECISIONS.md) — cache policy, timezone handling, error states, and explicit exclusions (no Marine API, no wave claims).

## Limitations

- Surfing uses weather-only inputs; waves/swell are not available.
- Skiing does not verify resort snow quality or lift operations.
- Forecast quality depends on Open-Meteo; offline use is limited to cached destinations.

## License

Private / coursework — see repository owner.
