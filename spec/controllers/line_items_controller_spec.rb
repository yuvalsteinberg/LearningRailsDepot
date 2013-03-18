require "spec_helper"

describe LineItemsController do

  before(:all) do
    @line_item = FactoryGirl.create(:line_item)
  end

  describe 'demo tests' do
    it "should get index" do
      get :index

      response.should be_success
      assigns(:line_items).should_not be_nil
    end

    it "should get new" do
      get :new
      response.should_not be_success
    end

    it "should create line_item" do
      product = FactoryGirl.create(:product, title: "LineItemsControllerTest")
      post :create, product_id: product.id

      assigns(:line_item).should_not be_nil
      assigns(:line_item).product.id
      response.should redirect_to cart_path(assigns(:line_item).cart)
    end

    it "should show line_item" do
      get :show, id: @line_item.id
      response.should be_success
    end

    it "should get edit" do
      get :edit, id: @line_item
      response.should be_success
    end
  end

end
