# Architecture

Daycast is a native **SwiftUI** app using lightweight **MVVM**. Network access and caching sit behind repositories; scoring is pure domain logic.

## Flow

```
Search → Activity Overview → Activity Ranking → Daily Detail (sheet)
```

## Layers

| Layer | Path | Responsibility |
|-------|------|----------------|
| Features | `Daycast/Features/` | Screens, view models, feature models |
| Domain | `Daycast/Domain/` | Shared domain types, availability, load results |
| Data | `Daycast/Data/` | Repositories, DTO mapping |
| Design system | `Daycast/Components/`, `Daycast/Core/Theme/` | Reusable UI |
| Core services | `Daycast/Core/Services/` | Open-Meteo client, cache, scoring engine |

### Feature map

| Plan name | Project folder |
|-----------|----------------|
| Search | `Features/DestinationSearch/` |
| Overview | `Features/ActivityOverview/` |
| Ranking | `Features/ActivityRanking/` |

## Data contracts

- **Geocoding**: Open-Meteo Geocoding API → `Destination` domain model.
- **Forecast**: Open-Meteo Forecast API → `DestinationForecastBundle` with destination-local `timezoneIdentifier` and daily ISO dates from the API.
- **Cache TTL**: six hours (`ForecastCachePolicy`).

## Testing

Unit tests live in `DaycastTests/` covering scoring, ranking, repositories, mapping and view models. Run with **⌘U** on an iOS Simulator.
