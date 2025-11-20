import { Controller } from "@hotwired/stimulus"
import embed from "vega-embed"
import * as vega from "vega"
import * as vegaLite from "vega-lite"

export default class extends Controller {
  static targets = ["dataset", "container"]

  connect() {
    this.render()
  }

  async render() {
    const payload = JSON.parse(this.datasetTarget.textContent)
    const name = payload.region_name || ""
    const code = payload.region_code || ""
    const width = payload.width || "container"
    const height = payload.height || 320

    // Country projection presets (center lon/lat and scale) for demo regions
    const presets = {
      USA: { center: [-98, 39], scale: 400 },
      GBR: { center: [-2, 54], scale: 1100 },
      FRA: { center: [2, 46], scale: 800 },
      DEU: { center: [10.5, 51], scale: 850 },
      BRA: { center: [-52, -10], scale: 430 },
      ZAF: { center: [24, -29], scale: 800 },
      IND: { center: [79, 22], scale: 650 },
      CHN: { center: [104, 35], scale: 500 },
      AUS: { center: [134, -25], scale: 650 },
      CAN: { center: [-100, 60], scale: 350 }
    }

    const proj = presets[code] || { center: [0, 20], scale: 300 }

    // Load local topojson via fetch and pass as inline values to avoid Vega's file loader
    let worldTopo
    try {
      const resp = await fetch('/data/world-110m.json')
      worldTopo = await resp.json()
    } catch (e) {
      console.warn('Map data load failed', e)
      return
    }

    const spec = {
      $schema: "https://vega.github.io/schema/vega-lite/v5.json",
      width,
      height,
      autosize: { type: "fit-x", contains: "padding" },
      projection: {
        type: "mercator",
        center: proj.center,
        scale: proj.scale
      },
      layer: [
        { data: { graticule: true }, mark: { type: "geoshape", stroke: "#f3f4f6", fill: null } },
        {
          data: {
            values: worldTopo,
            format: { type: "topojson", feature: "countries" }
          },
          mark: { type: "geoshape" },
          encoding: {
            fill: { value: "#e5e7eb" },
            stroke: { value: "#9ca3af" }
          }
        },
        {
          data: { values: [{ lon: proj.center[0], lat: proj.center[1], label: name }] },
          mark: { type: "point", color: "#ff7f0e", size: 60 },
          encoding: {
            longitude: { field: "lon", type: "quantitative" },
            latitude: { field: "lat", type: "quantitative" },
            tooltip: { field: "label", type: "nominal" }
          }
        }
      ]
    }

    const opts = { actions: false, vega, vegaLite }
    embed(this.containerTarget, spec, opts)
  }
}
