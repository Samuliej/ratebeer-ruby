require 'rails_helper'
require 'capybara/cuprite'

beer_names = ["Öylätti", "Fastenbier", "Lechte Weisse", "Nikolai"]
style_names = [ "Lager", "Rauchbier", "Weizen", "Pisswasser" ]
brewery_names = ["Koff", "Schlenkerla", "Ayinger", "Jii"]

style_names_sorted = style_names.sort
beer_names_sorted = beer_names.sort
brewery_names_sorted = brewery_names.sort

describe "Beerlist page", js: true do
  # En millään saanut seleniumilla toimimaan
  before :all do
    Capybara.register_driver :cuprite do |app|
      browser_options = {}.tap do |opts|
        opts['no-sandbox'] = nil if ENV['CI']
      end

      Capybara::Cuprite::Driver.new(
        app,
        headless: true,
        window_size: [1920, 1080],
        timeout: 60,
        process_timeout: 20,
        browser_options: browser_options
      )
    end

    Capybara.javascript_driver = :cuprite
    WebMock.disable_net_connect!(allow_localhost: true)
  end


  before :each do
    @brewery1 = FactoryBot.create(:brewery, name: brewery_names.first)
    @brewery2 = FactoryBot.create(:brewery, name: brewery_names.second)
    @brewery3 = FactoryBot.create(:brewery, name: brewery_names.third)
    @brewery4 = FactoryBot.create(:brewery, name: brewery_names.fourth)

    @style1 = Style.create name: style_names.first
    @style2 = Style.create name: style_names.second
    @style3 = Style.create name: style_names.third
    @style4 = Style.create name: style_names.fourth

    @beer1 = FactoryBot.create(:beer, name: beer_names.first, brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name: beer_names.second, brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name: beer_names.third, brewery:@brewery3, style:@style3)
    @beer4 = FactoryBot.create(:beer, name: beer_names.fourth, brewery:@brewery4, style:@style4)

    visit beerlist_path
  end

  it "shows a known beer", :js => true do
    find('table').find('tr:nth-child(2)')
    expect(page).to have_content "Nikolai"
  end

  it "beers should be sorted alphabetically by name", js: true do
    node = find('#beerlist').first('.tablerow')
    expect(node.text).to have_content beer_names_sorted.first
  end

  it "clicking style column sorts the beers by style alphabetically", js: true do
    find('table').find('#style').click
    node = find('#beerlist').first('.tablerow')
    expect(node.text).to have_content style_names_sorted.first
  end

  it "clicking brewery column sorts the beers by brewery alphabetically", js: true do
    find('table').find('#brewery').click
    node = find('#beerlist').first('.tablerow')
    expect(node.text).to have_content brewery_names_sorted.first
  end

end