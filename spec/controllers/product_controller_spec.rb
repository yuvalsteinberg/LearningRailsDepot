require "spec_helper"

describe ProductsController do
  before(:all) do
    @product = FactoryGirl.create(:product)
    @update = {
        title: 'Lorem Ipsum',
        description: 'Wibbles are fun!',
        image_url: 'lorem.jpg',
        price: 19.95
    }
  end

  describe 'demo tests' do

    it "should get index" do
      get :index

      response.should be_success
      assigns(:products).should_not be_nil
    end

    it "should get new" do
      get :new
      response.should be_success
    end

    it "should create product" do
      post :create, product: @update

      assigns(:product).should_not be_nil
      response.should redirect_to product_path(assigns(:product))
    end

    it "should show product" do
      get :show, id: @product
      response.should be_success
    end

    it "should get edit" do
      get :edit, id: @product
      response.should be_success
    end

    it "should update product" do
      put :update, id: @product, product: @update

      response.should redirect_to product_path(assigns(:product))
    end

  end

end
