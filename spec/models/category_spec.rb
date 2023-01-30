require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'scope test' do
    let!(:category1) { create(:category, name: 'category1', position: 1) }
    let!(:category2) { create(:category, name: 'category2', position: 3) }
    let!(:category3) { create(:category, name: 'category3', position: 2) }
    subject { Category.all.map { |c| [c.name, c.position] }.to_h }

    it "升冪排序" do
      expect(subject.keys).to match_array %w(category1 category3 category2)
      expect(subject.values[0] < subject.values[1]).to be true
      expect(subject.values[1] < subject.values[2]).to be true
    end
  end
end