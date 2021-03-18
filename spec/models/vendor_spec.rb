require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe 'validation' do
    let(:vendor) { Vendor.new }

    it 'name can not be empty' do
      expect(vendor).not_to be_valid
    end
  end
end
