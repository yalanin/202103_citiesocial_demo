require 'rails_helper'

RSpec.describe Admin::VendorsController, type: :controller do
  login_user

  describe '#index' do
    let!(:vendor1) { create(:vendor) }
    let!(:vendor2) { create(:vendor) }

    it 'should return all vendors' do
      get :index
      expect(assigns(:vendors).size).to eq(2)
    end
  end

  describe '#new' do
    it 'should return a new Vendor instance' do
      get :new
      expect(assigns(:vendor)).to be_a Vendor
      expect(assigns(:vendor).id).to be nil
    end

    it 'should return a new Vendor instance with params' do
      allow_any_instance_of(Admin::VendorsController).to receive(:flash).and_return( { params: { title: 'vendor test' } } )
      get :new
      expect(assigns(:vendor)).to be_a Vendor
      expect(assigns(:vendor).title).to eq('vendor test')
    end
  end

  describe '#create' do
    it 'should add params to vendor' do
      post :create, params: { vendor: { title: 'vendor title', description: 'vendor description', online: true } }
      expect(assigns(:vendor).title).to eq('vendor title')
      expect(assigns(:vendor).description).to eq('vendor description')
      expect(assigns(:vendor).online).to be true
    end

    it 'should create vendor success' do
      post :create, params: { vendor: { title: 'vendor title', description: 'vendor description', online: true } }
      expect(flash[:notice]).to eq('新增成功')
      expect(response).to redirect_to('/admin/vendors')
    end

    it 'should create vendor failed' do
      post :create, params: { vendor: { title: '', description: 'vendor description', online: true } }
      expect(flash[:error]).not_to be_empty
      expect(flash[:params]).to eq({"title"=>"", "description"=>"vendor description", "online"=>"true"})
      expect(response).to redirect_to('/admin/vendors/new')
    end
  end

  describe '#update' do
    let!(:vendor) { create(:vendor) }

    it 'should update vendor success' do
      patch :update, params: { id: 1, vendor: { title: 'vendor update' } }
      expect(assigns(:vendor).title).to eq('vendor update')
      expect(flash[:notice]).to eq('更新成功')
      expect(response).to redirect_to('/admin/vendors/1/edit')
    end

    it 'should update vendor failed' do
      patch :update, params: { id: 1, vendor: { title: '' } }
      expect(flash[:error]).not_to be_empty
      expect(response).to redirect_to('/admin/vendors/1/edit')
    end
  end

  describe '#destroy' do
    let!(:vendor) { create(:vendor) }

    it 'should destroy vendor success' do
      delete :destroy, params: { id: 1 }
      expect(flash[:notice]).to eq('廠商已刪除')
      expect(response).to redirect_to('/admin/vendors')
    end
  end
end