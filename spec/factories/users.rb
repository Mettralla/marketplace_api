FactoryBot.define do
  factory :user do
    email { 'one@one.org' }
    password_digest { 'hashed_password' }
  end
end