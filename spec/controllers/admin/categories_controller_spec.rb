require 'rails_helper'

RSpec.describe Admin::CategoriesController, type: :controller do
  login_user

  describe '#index' do
    let!(:category1) { create(:category, name: 'category1', position: 1) }
    let!(:category2) { create(:category, name: 'category2', position: 3) }
    let!(:category3) { create(:category, name: 'category3', position: 2) }
    it 'should order by position' do
      get :index
      res = assigns(:categories)
      map = res.map(&:position)
      expect(res.size).to eq(3)
      expect(map[0] < map[1]).to be true
      expect(map[1] < map[2]).to be true
    end
  end

  describe '#new' do
    it 'should return a new category instance' do
      get :new
      expect(assigns(:category)).to be_a Category
      expect(assigns(:category).id).to be nil
    end
  end

  describe '#create' do
    it 'should redirect to admin_categories_url' do
      post :create, params: { category: { name: 'create test', position: 1 } }
      expect(flash[:notice]).to eq('商品分類已新增')
      expect(response).to redirect_to('/admin/categories')
    end
  end

  describe '#update' do
    let!(:category1) { create(:category, name: 'category1', position: 1) }
    it 'should redirect to edit_admin_categories_url' do
      patch :update, params: { id: 1, category: {  name: 'update test' } }
      expect(flash[:notice]).to eq('分類已更新')
      expect(response).to redirect_to('/admin/categories/1/edit')
    end
  end

  describe '#destroy' do
    let!(:category1) { create(:category, name: 'category1', position: 1) }
    it 'should redirect to admin_categories_url' do
      delete :destroy, params: { id: 1 }
      expect(flash[:notice]).to eq('分類已刪除')
      expect(response).to redirect_to('/admin/categories')
    end
  end

  describe '#sort' do
    let!(:category1) { create(:category, name: 'category1', position: 1) }
    it 'should move to right position' do
      put :sort, params: { id: 1, to: 3 }
      expect(JSON.parse(response.body)['status']).to eq('ok')
    end
  end
end