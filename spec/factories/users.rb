# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email)      { |n| "test-#{n}@user.com" }
    password              { 'password'               }
    password_confirmation { 'password'               }
    authentication_token  { SecureRandom.hex(40)     }
  end
end
