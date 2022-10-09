FactoryBot.define do
  factory :user do
    email { 'one@one.org' }
    password_digest { BCrypt::Password.create('g00d_pa$$') }
  end
end
