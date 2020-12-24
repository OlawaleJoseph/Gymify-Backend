require 'rails_helper'

RSpec.describe GymSession, type: :model do
  context '#validations' do
    subject { build :gym_session }

    scenario { should validate_presence_of(:title) }
    scenario { should validate_length_of(:title).is_at_least(3) }
    scenario { should validate_length_of(:title).is_at_most(50) }

    scenario { should validate_presence_of(:description) }
    scenario { should validate_length_of(:description).is_at_least(3) }
    scenario { should validate_length_of(:description).is_at_most(5000) }

    scenario { should validate_presence_of(:duration) }
    scenario { should validate_numericality_of(:duration).only_integer }
    scenario { should validate_numericality_of(:duration).is_greater_than(299) }
    scenario { should validate_numericality_of(:duration).is_less_than(3600 * 2) }

    scenario { should validate_presence_of(:start_time) }

    it 'start time should be 10 minutes before current time' do
      invalid_start_time_session = subject
      invalid_start_time_session.start_time = Time.now
      invalid_start_time_session.save
      expect(invalid_start_time_session.errors.messages.keys).to include(:start_time)
      expect(invalid_start_time_session.errors.messages[:start_time]).to include('start time should be at least 10 minutes before now')
    end

    scenario { should be_valid }
  end

  context 'Associations' do
    scenario { should have_many(:appointments) }
    scenario { should have_many(:attendees).through(:appointments) }
  end
end
