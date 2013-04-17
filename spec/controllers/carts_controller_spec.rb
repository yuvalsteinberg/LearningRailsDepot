require "spec_helper"

describe CartsController do

  before(:all) do
    @cart = FactoryGirl.create(:cart)

  end

  describe 'demo tests' do
    before(:each) do
    end


    it "should get index", :test_failure => true do
      get :index

      assigns(:carts).should_not be_nil
      #response.should_not be_success
    end

    it "should get index", :slow=>true do
      get :index

      assigns(:carts).should_not be_nil
      response.should be_success
    end

    it "should get new" do
      get :new
      response.should be_success
    end

    it "should create cart" do
      post :create

      assigns(:cart).should_not be_nil
      response.should redirect_to cart_path(assigns(:cart))
    end

    it "should show cart" do
      get :show, id: @cart.id
      response.should be_success
    end

    it "should get edit" do
      get :edit, id: @cart.id
      response.should be_success
    end

    it "should update cart" do
      put :update, id: @cart
      response.should redirect_to cart_path(assigns(:cart))
    end

    it "should destroy cart" do
      #assert_difference('Cart.count', -1) do
      #  session[:cart_id] = @cart.id
      #  delete :destroy, id: @cart
      #end

      #assert_redirected_to store_path
    end
  end

end
