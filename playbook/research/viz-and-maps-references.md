# Data Viz + Maps — Reference Index

> **Status:** This file stands in for full scout reports. Three scout runs hit stream-idle timeouts before producing full reports; the two agent files (`data-viz-reviewer.md`, `maps-tooling-reviewer.md`) were written directly from domain knowledge. This file captures the sources those agents lean on, so any claim in the agent checklists can be chased down.

Last updated: 2026-04-22.

---

## Data visualization — canonical sources

### Books / deep references
- Edward Tufte, *The Visual Display of Quantitative Information* (2nd ed., 2001) — data-ink, small multiples, chartjunk.
- Claus O. Wilke, *Fundamentals of Data Visualization* (O'Reilly, 2019) — free at https://clauswilke.com/dataviz/. Practitioner canon for 2020s chart design.
- Alberto Cairo, *The Truthful Art* (2016) and *The Functional Art* (2013) — honesty and function over aesthetics.
- Jacques Bertin, *Semiology of Graphics* (1967, Esri reprint 2011) — the visual-variables vocabulary.
- Andy Kirk, *Data Visualisation: A Handbook for Data Driven Design* (2019) — chart taxonomy + design process.

### Frameworks / decision aids
- **Financial Times Visual Vocabulary** — https://github.com/Financial-Times/chart-doctor — the best compact chart-type selection guide.
- **Datawrapper Academy** — https://academy.datawrapper.de/ — practitioner-facing short guides.
- **Data Visualization Society** — https://www.datavisualizationsociety.org/

### Color
- **ColorBrewer 2.0** (Cynthia Brewer) — https://colorbrewer2.org/ — sequential / diverging / qualitative; colorblind / print / photocopy safety flags per palette.
- **Viridis / Cividis / Magma / Inferno / Plasma** palettes — matplotlib default since 2.0; perceptually uniform. Reference: https://matplotlib.org/stable/users/explain/colors/colormaps.html
- **Okabe-Ito 8-color palette** — https://jfly.uni-koeln.de/color/ — colorblind-safe categorical set.
- **Paul Tol color schemes** — https://personal.sron.nl/~pault/ — alternative colorblind-safe ramps.

### Accessibility
- **WCAG 2.2** — https://www.w3.org/TR/WCAG22/ — non-text contrast (§1.4.11), focus visibility, keyboard navigation.
- **axe DevTools** — https://www.deque.com/axe/ — automated a11y auditor.
- **pa11y** — https://pa11y.org/ — CLI a11y testing, CI-friendly.
- **Coblis** (Color Blindness Simulator) — https://www.color-blindness.com/coblis-color-blindness-simulator/
- **Sim Daltonism** (macOS) — https://michelf.ca/projects/sim-daltonism/

### Python libraries (state of the art 2026)
- **matplotlib** — https://matplotlib.org/ — static plotting standard.
- **seaborn** — https://seaborn.pydata.org/ — high-level statistical plots on matplotlib.
- **plotnine** — https://plotnine.readthedocs.io/ — ggplot2 grammar of graphics in Python.
- **Plotly Python** — https://plotly.com/python/ — interactive + Dash.
- **Bokeh** — https://bokeh.org/ — interactive web-native.
- **Altair (Vega-Lite)** — https://altair-viz.github.io/ — declarative grammar.
- **HoloViews / Panel / hvPlot** — https://holoviz.org/ — Anaconda stack.

### Dashboard frameworks
- **Streamlit** — https://streamlit.io/ — fastest solo-dev ship.
- **Dash (Plotly)** — https://dash.plotly.com/ — more customizable.
- **Panel** — https://panel.holoviz.org/
- **Solara** — https://solara.dev/ — React-style Python.
- **Marimo** — https://marimo.io/ — reactive notebooks + app deploy.

### JavaScript / web libraries
- **D3** — https://d3js.org/ — low-level visualization grammar.
- **Observable Plot** — https://observablehq.com/plot/ — high-level, D3-adjacent.
- **ECharts** — https://echarts.apache.org/ — Apache, feature-rich interactive.
- **Chart.js** — https://www.chartjs.org/ — simple, canvas-based.
- **Plotly.js** — https://plotly.com/javascript/
- **Vega-Lite** — https://vega.github.io/vega-lite/

### Anti-pattern catalogues
- "Calling Bullshit" — https://www.callingbullshit.org/ — Bergstrom & West on misleading viz.
- WTFViz — https://viz.wtf/ — worst-of gallery.
- Darkhorse Analytics — "Remove to Improve" video — https://www.darkhorseanalytics.com/ (the classic chartjunk removal demo).

---

## Maps / regional analysis — canonical sources

### Tile providers
- **OpenStreetMap Tile Usage Policy** — https://operations.osmfoundation.org/policies/tiles/ — **hard rule: do not hit osm.org from production.**
- **Stadia Maps** — https://stadiamaps.com/ — hosts Stamen now. Generous free tier.
- **MapTiler** — https://www.maptiler.com/ — 100k tiles/mo free.
- **Mapbox** — https://www.mapbox.com/ — tiles + styling + geocoding + directions.
- **CARTO** — https://carto.com/basemaps/ — free basemaps for analytics.
- **Thunderforest** — https://www.thunderforest.com/ — transport + outdoors.
- **Protomaps / PMTiles** — https://protomaps.com/ — single-file cloud-native tiles. **2024–2025 major shift.**

### Map libraries
- **Leaflet** — https://leafletjs.com/ — the pragmatic default for 2D web maps.
- **MapLibre GL JS** — https://maplibre.org/ — open fork of Mapbox GL JS v1 post license change.
- **Mapbox GL JS** — https://docs.mapbox.com/mapbox-gl-js/ — commercial successor line.
- **OpenLayers** — https://openlayers.org/ — still relevant for complex projections / WMS.
- **deck.gl** — https://deck.gl/ — WebGL layered viz, excellent at large datasets.
- **kepler.gl** — https://kepler.gl/ — drop-in geospatial analytics UI.
- **Cesium** — https://cesium.com/ — 3D globe.

### Leaflet plugin ecosystem
- **Leaflet.markercluster** — https://github.com/Leaflet/Leaflet.markercluster — mandatory for >500 markers.
- **Leaflet.heat** — https://github.com/Leaflet/Leaflet.heat — fast heatmap layer.
- **Leaflet.draw** — https://github.com/Leaflet/Leaflet.draw — drawing / editing geometries.
- **Leaflet.glify** — https://github.com/robertleeplummerjr/Leaflet.glify — WebGL for very large point sets.
- **Leaflet.VectorGrid** — https://github.com/Leaflet/Leaflet.VectorGrid — vector tile rendering.

### Geospatial formats
- **GeoJSON (RFC 7946)** — https://datatracker.ietf.org/doc/html/rfc7946 — interchange standard.
- **TopoJSON** — https://github.com/topojson/topojson — 50–80% smaller for shared-boundary polygons.
- **GeoPackage** — https://www.geopackage.org/ — modern shapefile replacement, OGC standard.
- **FlatGeobuf** — https://flatgeobuf.org/ — streaming large feature sets.
- **PMTiles** — https://docs.protomaps.com/pmtiles/ — single-file cloud tiles.
- **GeoParquet** — https://geoparquet.org/ — analytics pipelines.

### Projections
- **EPSG.io** — https://epsg.io/ — CRS lookup.
- **proj4js** — https://github.com/proj4js/proj4js — browser reprojection.
- **proj (C library)** — https://proj.org/ — server-side reprojection backbone.
- Texas State Plane zones:
  - EPSG:2276 / 32138 — North
  - EPSG:2277 / 32139 — North Central
  - EPSG:2278 / 32140 — Central
  - EPSG:2279 / 32141 — South Central
  - EPSG:2280 / 32142 — South

### Geospatial Python
- **GeoPandas** — https://geopandas.org/
- **Shapely** — https://shapely.readthedocs.io/
- **Fiona** — https://fiona.readthedocs.io/
- **rasterio** — https://rasterio.readthedocs.io/
- **folium / ipyleaflet** — notebook-embedded Leaflet.
- **pydeck** — https://deckgl.readthedocs.io/ — deck.gl for Python.

### Clustering / binning
- **Supercluster** — https://github.com/mapbox/supercluster — fast point clustering.
- **H3** (Uber) — https://h3geo.org/ — hexagonal hierarchical spatial index.
- **S2** (Google) — https://s2geometry.io/ — alternative hex/cell index.
- **tippecanoe** — https://github.com/felt/tippecanoe — vector tile pipeline from GeoJSON → MBTiles/PMTiles.

### Geocoding
- **US Census Geocoder** — https://geocoding.geo.census.gov/ — free, batch-friendly. Essential for US campaign work.
- **Nominatim** — https://nominatim.org/ — OSM-based. Respect public-instance rate limits; self-host for volume.
- **Pelias** — https://pelias.io/ — open-source hosted option.
- **Mapbox Geocoding** — https://docs.mapbox.com/api/search/geocoding/ — paid, quality + autocomplete.
- **Google Geocoding** — paid, best edge-case quality + places.

### Routing / isochrones
- **Valhalla** — https://valhalla.github.io/valhalla/ — open-source routing + isochrone.
- **OSRM** — http://project-osrm.org/ — open-source routing.
- **GraphHopper** — https://www.graphhopper.com/ — commercial + OSS core.
- **Mapbox Isochrone API** — https://docs.mapbox.com/api/navigation/isochrone/

### Regional analytics
- **US Census ACS API** — https://www.census.gov/data/developers/data-sets/acs-5year.html
- **TIGER/Line shapefiles** — https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.html
- **`censusdata`, `pygris`, `censusgeocode`** Python packages.

### Map anti-patterns / cartography
- "How to Lie with Maps" — Mark Monmonier.
- FlowingData — https://flowingdata.com/ — practitioner commentary on data + map design.
- Andy Kirk's Blog — https://visualisingdata.com/

### Accessibility for maps
- WCAG guidance on map-shaped widgets — https://www.w3.org/WAI/WCAG22/Techniques/
- Leaflet keyboard navigation docs — https://leafletjs.com/reference.html#map-option (see `keyboard` option).

---

## Usage notes for the two agents

Both `data-viz-reviewer` and `maps-tooling-reviewer` cite these sources by name without deep-linking inside the agent body (to keep the agents tight). When a reviewer session produces a finding ("palette is rainbow on sequential data"), the agent should point at the relevant source here — e.g., "See references → ColorBrewer / Viridis entries."

Keep this file pruned: when a library or source goes stale, move it to a `deprecated/` section or delete.
