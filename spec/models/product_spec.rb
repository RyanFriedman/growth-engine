require 'rails_helper'

RSpec.describe Product, type: :model do
  it { is_expected.to have_many(:line_items) }
end