require 'rails_helper'

RSpec.describe Notification, type: :model do
  subject { build :notification }

  scenario { should validate_presence_of(:message) }

  scenario { should belong_to(:receiver) }
end
