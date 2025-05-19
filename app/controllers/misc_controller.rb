class MiscController < ApplicationController
  def calculator
    @vat = 0.25
    @beer_sizes = [
      0.33, 0.375, 0.5, 0.568, 0.66, 0.75, 1, 1.3, 1.5
    ]
  end
end
