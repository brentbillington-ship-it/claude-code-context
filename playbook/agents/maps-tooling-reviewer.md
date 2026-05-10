# maps-tooling-reviewer

> **Purpose:** Review map applications, regional-analysis viz, and geospatial pipelines. Covers tile strategy, projection correctness, performance, geocoding, accessibility, and map-specific anti-patterns. Pairs with `data-viz-reviewer` for chart-side overlays.

## When to Invoke
- Before shipping any map tool to a client (Billington Works)
- Before a Canvassing Map or Signs Map release
- When scaling an existing map beyond ~500 points
- When adding a new map feature (heatmap, choropleth, isochrone, trade area)
- When reviewing regional-analysis deliverables (Municipal Markets, demographic overlays)
- When a client asks for offline / PWA capability on a map

## Prerequisites
- Live URL or local dev server for the map
- Source code for the map page + layer configuration
- Access to sample data at production scale (not a toy subset)
- Target tile provider API keys (for paid providers, confirm they're properly restricted)
- Playwright CLI/MCP for interactive inspection

## Playbook

### 1. Tile-provider strategy
**Hard fail** if the map hits `osm.org` / `tile.openstreetmap.org` tiles directly from production — that violates OSM's tile usage policy and will get the map rate-limited or blocked. Approved options:

| Provider | Free tier? | Best for |
|---|---|---|
| **Stadia Maps** / Stamen (hosted by Stadia) | yes, generous | General use, Stamen artistic styles |
| **MapTiler** | yes, 100k tiles/mo free | Commercial, good styles |
| **CARTO** | yes, basemaps free | Business analytics basemaps |
| **Mapbox** | yes, limited | High-quality tiles + vector + geocoding bundle |
| **Thunderforest** | yes, limited | Transport, outdoors |
| **ESRI** | paid usually | Enterprise / Halff work |
| **Self-hosted PMTiles** | free | Large static datasets; single-file cloud-native |
| **Self-hosted MBTiles + tileserver-gl / martin** | free | Full control, server cost |

Check:
- API key NOT exposed in the client bundle for paid providers — use domain-restriction on the key
- Attribution text present on the map (every provider requires it)
- Tile usage pattern respects rate limit — caching headers honored
- For client work: paid-tier key belongs to client's account, not yours

### 2. Projection correctness
- **Web Mercator (EPSG:3857)** — fine for tile-based interactive maps at city/state scale
- **National or regional comparison maps** — Web Mercator distorts area badly toward the poles. Use equal-area (Albers USA, Lambert Azimuthal) for choropleths where area-accuracy matters
- **Texas civil engineering** — Brent is Texas PE. State Plane zones:
  - NAD83 / Texas North (EPSG:2276 ft, 32138 m)
  - NAD83 / Texas North Central (EPSG:2277 ft, 32139 m)
  - NAD83 / Texas Central (EPSG:2278 ft, 32140 m)
  - NAD83 / Texas South Central (EPSG:2279 ft, 32141 m)
  - NAD83 / Texas South (EPSG:2280 ft, 32142 m)
- **Declare the projection** in exported data (GeoJSON has no CRS assumption; GeoPackage does)
- **Coordinate precision** — 6 decimal places of lat/lon ≈ 0.11 m; more is false precision and inflates file size

### 3. Performance gates (count of features)
- **<500 markers** → native Leaflet markers fine
- **500–10k markers** → cluster (Leaflet.markercluster or Supercluster) mandatory
- **>10k points** → vector tiles (tippecanoe → PMTiles) or WebGL (deck.gl, Leaflet.glify, Mapbox GL)
- **Choropleth with >1k polygons** → TopoJSON (not GeoJSON) for size; or vector tiles
- **Heatmap** → pre-aggregate to H3 or S2 hex bins at appropriate resolution (don't recompute kernel density client-side on every pan/zoom)

### 4. Heatmap honesty
Heatmaps are easily abused. Checklist:
- **Rates, not raw counts** — a heatmap of "voters" is just a population map; normalize by population, area, or exposure
- **Bandwidth sensible** — a kernel density with too-wide bandwidth lies; too narrow is noise
- **Privacy** — address-point heatmaps can leak individual identity in low-density areas; aggregate to a coarser resolution (H3 resolution 8–9 typical for urban; 10–11 for rural)
- **Color scale** — sequential single-hue or Viridis family, NEVER rainbow/jet
- **Legend explains the unit** — "density of X per Y" not "intensity"

### 5. Choropleth honesty
- **Normalize the numerator** — counts over area, counts over population, etc. Raw-count choropleths are the top regional-analysis anti-pattern
- **Classification** — quantiles for skewed data, natural breaks (Jenks) for cluster-revealing, equal-intervals only for truly uniform distributions
- **Don't over-class** — 5 classes is usually enough; 7 is the ceiling for categorical distinction
- **Bivariate choropleths** — powerful but legibility-limited; only for advanced audiences and with a 2D legend block

### 6. Geospatial formats
| Format | Use for |
|---|---|
| **GeoJSON** | API responses, small boundary sets, interchange |
| **TopoJSON** | Shared-boundary polygons (US counties) — 50–80% smaller |
| **Shapefile** | Legacy interop only — avoid for new work |
| **GeoPackage (.gpkg)** | Modern replacement for shapefile; single file; carries CRS |
| **FlatGeobuf** | Streaming large feature sets |
| **PMTiles** | Single-file cloud-native tiles (big shift vs. tile servers) |
| **GeoParquet** | Analytics pipelines |

Check:
- Files >5 MB in GeoJSON → switch format or vector-tile it
- Coordinate precision truncated (6 decimal places is plenty)
- CRS declared or Web Mercator assumed appropriately

### 7. Geocoding
Pick provider by use case:

| Provider | Free? | Best for |
|---|---|---|
| **US Census Geocoder** | yes | Batch geocoding US addresses (campaign work) |
| **Nominatim (OSM)** | yes if self-hosted | Light global; respect public-instance rate limits |
| **Pelias** | yes if self-hosted | Open-source Mapbox alternative |
| **Mapbox Geocoding** | paid | Quality + autocomplete UX |
| **Google Maps Geocoding** | paid | Edge-case quality + places |
| **HERE / Esri** | paid | Enterprise + non-US coverage |

Check:
- **Batch when possible** — don't call the API once per row in a CSV
- **Cache** — persistent SQLite or Parquet cache; 1 row per (input → output)
- **PII discipline** — full street addresses are PII; cache in an encrypted or access-controlled store for client work
- **Geocoding failure handling** — null + reason, not silent drop

### 8. Regional / business-analytics patterns
- **Trade-area analysis** — customer-origin plotting, drive-time isochrones (Mapbox Isochrone API, Valhalla, OSRM)
- **Drive/walk-time isochrones** — prefer a service over bespoke routing unless volume justifies
- **Site selection** — gravity / Huff models for retail; Census ACS for demographic inputs
- **Canvassing turf cutting** — balanced partitioning (walkshed / precinct / equal-voter-count); document the algorithm
- **Demographic overlays** — ACS API via `censusdata` / `pygris`; TIGER shapefiles for geometries

### 9. Offline / field-canvassing patterns
- **Service worker tile cache** for short-term offline
- **Bundled MBTiles / PMTiles** inside the app for longer offline windows
- **State persistence** (IndexedDB) for walk-list progress
- **Sync on reconnect** — conflict resolution strategy documented

### 10. Accessibility
- **Keyboard navigation** — tab to interactive markers; arrow-key panning; +/- zoom; `/` search-focus
- **ARIA labels** on marker layers; `role="application"` only if custom keyboard handling is complete
- **Textual feature list** alternative — the screen-reader user needs a non-visual path to the information
- **Color-blind-safe** choropleth palette (see `data-viz-reviewer` palette section)
- **Zoom to feature** from a list entry

### 11. Anti-pattern sweep
- Hitting `osm.org` tiles from production — hard fail
- Raw counts as choropleth — hard fail
- Rainbow palette on sequential data — hard fail
- Web Mercator used for area comparison — fail
- Markers for >1000 points without clustering — fail
- Reverse-geocoding PII without caching / consent — fail for client work
- Leaflet layer without attribution — fail (license requirement)
- Hard-coded API key in client bundle for paid provider — fail
- Missing scale bar on analytic / planning map — fail
- Geocoding loop without caching — cost risk flag
- Heatmap of population presented as "activity" — honesty flag

### 12. 2026 shifts worth knowing
- **PMTiles adoption** — single-file cloud-native tile hosting replacing tile servers for many use cases
- **MapLibre GL JS** — the open fork of Mapbox GL JS v1 post-license-change; most new OSS map projects use MapLibre
- **deck.gl** — matured; now the default for very large-dataset map viz
- **Valhalla / OSRM self-hosted routing** — viable for cost control on isochrone-heavy analytics

### 13. Output the review
Produce `reviews/maps/<map-name>-<YYYY-MM-DD>.md` with: tile-strategy findings, projection, performance, heatmap/choropleth honesty, geocoding discipline, accessibility, anti-patterns, recommendations. Screenshots from multiple zoom levels.

## Success Criteria
- Tile provider approved and API-key-disciplined
- Projection appropriate for the use case; CRS stated on exports
- Performance gate respected (clustering / vector tiles / WebGL as needed)
- Heatmap / choropleth normalized and palette-safe
- Geocoding batched + cached + PII-aware
- Accessibility checklist addressed
- No hard-fail anti-patterns

## Failure Modes & Recovery
- **Dataset too large for the chosen library** → recommend format/library swap (PMTiles, vector tiles, deck.gl); don't accept sluggish UX
- **Client requires Google Maps specifically** → accept but review for key restriction + attribution + cost modeling
- **Offline requirement but server-only tile provider** → recommend switching to self-hosted PMTiles or negotiate scope
- **Halff civil work needing State Plane overlay on a web map** → separate the engineering exhibit (State Plane, print) from the web map (Web Mercator, interactive); don't mix

## Output Artifacts
- `reviews/maps/<map-name>-<YYYY-MM-DD>.md`
- `reviews/maps/<map-name>-<YYYY-MM-DD>/screenshots/` (multiple zooms, layers)
- Links: `data-viz-reviewer` for chart overlays; `halff-brand-auditor` for Halff-branded maps; `security-scanner` if PII handling involved

## References (see `research/viz-and-maps-references.md`)
- OpenStreetMap Tile Usage Policy
- Protomaps PMTiles spec
- MapLibre docs
- H3 hex binning (Uber)
- US Census Geocoder API
- Mapbox / Valhalla Isochrone APIs
- ColorBrewer (Cynthia Brewer)
- ESRI State Plane zone reference
