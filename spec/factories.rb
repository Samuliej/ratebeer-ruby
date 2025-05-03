FactoryBot.define do
  factory :user do
    username { "Pekka" }
    password { "F00bar%" }
    password_confirmation { "F00bar%" }
  end

  factory :brewery do
    name { "anonymous" }
    year { 1900 }
  end

  factory :style do
    name { "Lager" }
    description { "Lager description" }
  end

  factory :beer do
    name { "anonymous" }
    style
    brewery
  end

  factory :rating do
    score { 10 }
    beer
    user
  end

  factory :beer_club do
    name { "club anonymous" }
    founded { 1959 }
    city { "anocity" }
  end

  factory :membership do
    confirmed { false }
    beer_club
    user
  end
end
