require 'faker'

FactoryBot.define do
  factory :program do
    configuration { { auto_resolve: false, auto_define: true } }
  end
  factory :user, aliases: %i[receiver] do
    email { Faker::Internet.email }
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.name }
    password { 'Password1' }
    username { Faker::Name.unique.name }
    image { Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, 'spec/images/bubbles.jpg')), 'image/jpeg') }
  end

  factory :trainer, class: 'User' do
    email { Faker::Internet.email }
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.name }
    password { 'Password1' }
    username { Faker::Name.unique.name }
    is_trainer { true }
    speciality { 'Squats' }
    info { '5 years experience as a professional trainer' }
    image { Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, 'spec/images/bubbles.jpg')), 'image/jpeg') }
  end

  factory :appointment do
    attendee_id { 1 }
    gym_session_id { 1 }
    confirmed { false }
  end

  factory :gym_session do
    association :instructor, factory: :trainer
    title { 'Six Packs workout' }
    description { 'Description' }
    start_time { Time.now + 1000 }
    duration { 60 * 30 }
  end

  factory :notification do
    message { 'Notification message' }
    receiver factory: :user
    is_read { false }
  end
end
