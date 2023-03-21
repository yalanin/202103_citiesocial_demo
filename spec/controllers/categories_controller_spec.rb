require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let!(:category) { create(:category) }

  describe '#show' do
    it '顯示類別' do
      get :show, params: { id: category.id }
      expect(response).to render_template('show')
    end
  end
end