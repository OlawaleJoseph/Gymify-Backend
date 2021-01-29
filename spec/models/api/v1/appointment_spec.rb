require 'rails_helper'

RSpec.describe Appointment, type: :model do
  subject { build :appointment }
  context 'Associations' do
    scenario { should belong_to(:attendee) }
    scenario { should belong_to(:gym_session) }
  end
end
