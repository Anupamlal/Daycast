# Daycast scoring heuristics

Daycast scores are **transparent product heuristics**, not probabilities of success. All activities share one normalized seven-day Open-Meteo forecast per destination.

Implementation: `Daycast/Core/Services/ActivityScoring/`.

## Thresholds

| Band | Score range | Label |
|------|-------------|--------|
| Suitable | 70–100 | Suitable |
| Uncertain | 45–69 | Uncertain |
| Not suitable | 0–44 | Not suitable |

A day counts toward **suitable-day totals** on Screen 2 when its daily score is **≥ 70**. Missing forecast days are **excluded** from averages, rankings, and suitable-day counts (never treated as zero).

## Activity weights (conceptual)

Each activity combines daily signals from the same forecast row:

| Activity | Primary positive signals | Primary penalties |
|----------|-------------------------|-------------------|
| Skiing | Cold max temps, snow weather codes | Mild temps, heavy precip (non-snow context) |
| Surfing (proxy) | Mild temps, moderate wind | Rain, extreme wind |
| Outdoor sightseeing | Comfortable temps, low precip/light wind | Rain, heat/cold extremes, strong wind |
| Indoor sightseeing | Adverse outdoor conditions (inverse of outdoor comfort) | Fair outdoor weather (fewer indoor-only days) |

Optional **sunshine duration** contributes when returned by the API. Missing optional fields are omitted from factor lists; if required arrays are misaligned, the day is **unavailable**.

## Ranking (Screen 3)

- Sort scored days by **score descending**.
- Ties break on **earlier destination-local date** (ISO `yyyy-MM-dd` from the API).
- Unavailable days appear after ranked days, ordered by date, with **no rank** and **no score**.

## Normalization & missing data

- Do not convert missing values to **0**.
- Unavailable days are excluded from rank and suitable-day counts.
- Partial seven-day coverage shows explicit partial-data copy on overview/ranking when material.

## Activities

- **Surfing** uses a **weather proxy** only; wave/swell are not modeled.
- **Skiing** may reference snow/precip signals but does **not** assert resort operations or snow quality.

## Safety

Thunderstorm weather codes and very high wind can surface a **safety caution** in daily detail. A high activity score does not override safety messaging.

## Cache (data, not scoring)

Forecast bundles are cached for **six hours** (`ForecastCachePolicy`) before a refresh is attempted.
