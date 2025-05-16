require "rails_helper"
require 'capybara/cuprite'

include Helpers

# describe "Breweries page", js: true do
#   before :all do
#     Capybara.register_driver :cuprite do |app|
#       browser_options = {}.tap do |opts|
#         opts['no-sandbox'] = nil if ENV['CI']
#       end
#
#       Capybara::Cuprite::Driver.new(
#         app,
#         headless: true,
#         window_size: [1920, 1080],
#         timeout: 60,
#         process_timeout: 20,
#         browser_options: browser_options
#       )
#     end
#
#     Capybara.javascript_driver = :cuprite
#     WebMock.disable_net_connect!(allow_localhost: true)
#   end
#
#
#   it "should not have any before been created" do
#     visit breweries_path
#     expect(page).to have_content "Breweries"
#   end
#
#   describe "when breweries exist" do
#     before :each do
#       @breweries = %w[Koff Karjala Schlenkerla]
#       year = 1896
#       @breweries.each do |brewery_name|
#         FactoryBot.create(:brewery, name: brewery_name, year: year += 1, active: true)
#       end
#
#       visit breweries_path
#     end
#
#     it "lists the existing breweries and their total number" do
#       expect(page).to have_content "Number of active breweries: #{@breweries.count}"
#       @breweries.each do |brewery_name|
#         expect(page).to have_content brewery_name
#       end
#     end
#
#     it "allows user to navigate to page of a Brewery" do
#       save_and_open_page
#
#       click_link "Koff", wait: 5
#
#       expect(page).to have_content "Koff", wait: 5
#       expect(page).to have_content "Established in 1897", wait: 5
#     end
#   end
# end