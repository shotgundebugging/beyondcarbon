import { Controller } from "@hotwired/stimulus"
import embed from "vega-embed"
import * as vega from "vega"
import * as vegaLite from "vega-lite"

export default class extends Controller {
  static targets = ["dataset", "container"]

  connect() {
    this.render()
  }

  render() {
    const payload = JSON.parse(this.datasetTarget.textContent)
    const data = (payload.data || []).map(d => ({
      sector: d.sector,
      value: Number(d.value)
    }))

    const spec = {
      $schema: "https://vega.github.io/schema/vega-lite/v5.json",
      title: payload.title || "",
      data: { values: data },
      width: payload.width || 900,
      height: payload.height || 400,
      mark: { type: "bar", tooltip: true },
      encoding: {
        x: { field: "sector", type: "nominal", sort: null, title: "Sector" },
        y: {
          field: "value",
          type: "quantitative",
          title: payload.y_title || "Value",
          scale: { nice: true }
        },
        color: { field: "sector", type: "nominal", legend: null }
      }
    }

    const opts = { actions: false, vega, vegaLite }
    embed(this.containerTarget, spec, opts)
  }
}
