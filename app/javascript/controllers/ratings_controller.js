import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  destroy() {
    const confirmDelete = confirm("Are you sure you want to delete these selected ratings?")
    if (!confirmDelete) return

    const selectedRatingsIDs = Array.from(
      document.querySelectorAll('input[name="ratings[]"]:checked'),
      (checkbox) => checkbox.value
    )

    // Include the csrf token so rails recognizes us as the logged in user
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    const headers = { "X-CSRF-Token": csrfToken }

    fetch("/ratings", {
      method: "DELETE",
      headers: headers,
      body: selectedRatingsIDs.join(",")
    })
      .then((response) => {
        if (response.ok) {
          response.text().then((html) => {
            document.querySelector("div.ratings").innerHTML = html
          })
        } else {
          throw new Error("Something went wrong")
        }
      })
      .catch((error) => {
        console.log(error)
      })
  }

  selectAll() {
    const checkboxes = document.querySelectorAll(".rating-checkbox")

    if ([...checkboxes].every(c => c.checked === true)) {
      checkboxes.forEach(c => c.checked = false)
    } else {
      checkboxes.forEach(c => c.checked = true)
    }
  }
}