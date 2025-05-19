import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "amount", "abv", "price", "customAmount" ]
  static values = { vat: Number }

  calculate(event) {
    event.preventDefault()
    const rawAmount = this.amountTarget.value

    let amount = 0
    if (rawAmount === "Custom") {
      amount = parseFloat(this.customAmountTarget.value)
    } else {
      amount = parseFloat(rawAmount)
    }

    const abv = parseFloat(this.abvTarget.value)
    const price = parseFloat(this.priceTarget.value)


    let alcoholTax = 0
    switch (true) {
      case (abv < 0.5):
        alcoholTax = 0
        break
      case (abv <= 3.5):
        alcoholTax = 0.2835
        break
      case (abv > 3.5):
        alcoholTax = 0.3805
        break
      default:
        alcoholTax = 0
        break
    }

    const beerTax = (amount * abv * alcoholTax)
    const vatAmount = (price - (price / (1.0 + this.vatValue)))
    const taxPercentage = ((beerTax + vatAmount) / price * 100)

    const result = document.getElementById("result")
    result.innerHTML = `
      <p>Beer has ${beerTax.toFixed(2)} € of alcohol tax and ${vatAmount.toFixed(2)} € of value added tax.</p>
      <p>${taxPercentage.toFixed(1)} % of the price is taxes.</p>
    `
  }

  reset() {
    document.getElementById("result").innerHTML = ""
  }

}