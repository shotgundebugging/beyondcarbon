import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submit() {
    // Submit the form (GET) and let Turbo update the target frame
    this.element.requestSubmit()
  }
}

