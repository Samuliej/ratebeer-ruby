import { beers } from "custom/beers"
import { breweries } from "./custom/breweries"

beers()
breweries()

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"
