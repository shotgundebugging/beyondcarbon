import { Controller } from "@hotwired/stimulus"
import embed from "vega-embed"
import * as vega from "vega"
import * as vegaLite from "vega-lite"

export default class extends Controller {
  static targets = ["region", "stressor", "dataset", "topn", "topnValue", "sort"]

  connect() { this.render() }

  onRegionChange() {
    const params = new URLSearchParams(window.location.search)
    params.set("region", this.regionTarget.value)
    params.set("stressor", this.stressorTarget.value)
    window.location.search = params.toString()
  }

  render() {
    this.topnValueTarget.textContent = this.topnTarget.value

    const regionData = JSON.parse(this.datasetTarget.textContent)
    const stressor = this.stressorTarget.value
    let data = (regionData[stressor] || []).map(d => ({
      sector: d.sector,
      value: Number(d.value)
    }))


    const sortMode = this.sortTarget.value
    if (sortMode === "asc") data.sort((a, b) => a.value - b.value)
    else if (sortMode === "desc") data.sort((a, b) => b.value - a.value)
    else data.sort((a, b) => a.sector.localeCompare(b.sector))

    const topN = parseInt(this.topnTarget.value, 10) || data.length
    data = data.slice(0, topN)

    const regionLabel = this.regionTarget.selectedOptions?.[0]?.text || this.regionTarget.value

    const spec = {
      $schema: "https://vega.github.io/schema/vega-lite/v5.json",
      title: `${stressor} — ${regionLabel}`,
      data: { values: data },
      width: 900,
      height: 400,
      mark: { type: "bar", tooltip: true },
      encoding: {
        x: { field: "sector", type: "nominal", sort: null, title: "Sector" },
        y: {
          field: "value",
          type: "quantitative",
          title: "Employment (people)",
          scale: { nice: true }
        },
        color: { field: "sector", type: "nominal", legend: null }
      }
    }

    const opts = { actions: false, vega, vegaLite }
    embed("#chart", spec, opts)
  }
}
