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

  factory :beer do
    name { "anonymous" }
    style { "Lager" }
    brewery
  end

  factory :rating do
    score { 10 }
    beer
    user
  end
end
