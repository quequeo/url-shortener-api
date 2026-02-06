require 'rails_helper'

RSpec.describe Visit, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:visit)).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to link' do
      visit = build(:visit)
      expect(visit.link).to be_present
    end
  end
end
