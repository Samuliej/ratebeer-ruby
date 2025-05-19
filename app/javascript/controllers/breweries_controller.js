import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "name", "year", "active" ]

  onSubmitEnd(event) {
    this.nameTarget.value = ""
    this.yearTarget.value = ""
    this.activeTarget.checked = false
  }
}