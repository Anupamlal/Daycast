# Engineering decisions

## MVVM and layering

- **ViewModels** own presentation state and call **repositories**; they do not decode JSON or compute scores.
- **Repositories** (`ForecastRepository`, `GeocodingRepository`) wrap Open-Meteo access and cache persistence for testability.
- **Scoring** stays in `ActivityScoringEngine` and related builders so ranking is deterministic and unit-testable.

## APIs and scope

- **Open-Meteo Geocoding + Forecast** only. No custom backend, no Marine API.
- **Surfing** is a **weather proxy**; wave/swell are not modeled and must not be implied in UI copy.
- **Skiing** uses forecast temperature/precip/snow codes only; no resort or lift guarantees.

## Timezone and dates

- Seven-day windows use **API daily `time` values** and the forecast response **`timezone`**, not the device calendar alone.
- Date labels on Screen 3 format with the bundle’s `timezoneIdentifier`.

## Cache and errors

- Forecast cache **TTL = 6 hours** (`ForecastCachePolicy`).
- Valid cache is shown immediately; stale cache triggers background refresh while keeping data visible.
- Refresh failures keep the last cached bundle when possible and surface a notice instead of fabricating data.
- Search requests are **debounced**; stale responses are ignored via a request token.

## Missing data

- Days that cannot be scored are **unavailable**, not scored as zero.
- Partial forecast coverage is disclosed in overview and ranking copy.

## UI conventions

- Shared typography, spacing (`DaycastLayoutMetric`), semantic colors (`DaycastAssetColor`) and enum-backed strings (`Core/Constants/`).
- Status labels always accompany color (Suitable / Uncertain / Not suitable).

## Out of scope (submission)

- Accounts, push notifications, maps, animations, settings, charts beyond score bars.
- Fabricated sample cities in production empty states.
