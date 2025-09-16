# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "vega", to: "https://esm.sh/vega@5"
pin "vega-lite", to: "https://esm.sh/vega-lite@5"
pin "vega-embed", to: "https://esm.sh/vega-embed@6"
