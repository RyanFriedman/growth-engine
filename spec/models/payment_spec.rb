require 'rails_helper'

RSpec.describe Payment, type: :model do
  it { is_expected.to belong_to(:order) }
end