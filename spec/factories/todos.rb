# frozen_string_literal: true

FactoryBot.define do
  factory :todo do
    name        { 'Buy milk'              }
    description { 'Remember to buy milk.' }

    user
  end
end
