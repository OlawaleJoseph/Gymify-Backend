require 'faker'

FactoryBot.define do
  factory :gym_session do
    title { 'Six Packs workout' }
    description { 'Description' }
    start_time { Time.now + 1000 }
    duration { 60 * 30 }
  end
end
