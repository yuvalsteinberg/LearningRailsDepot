require "spec_helper"

describe StoreController do

  describe 'demo tests' do
    it "should get index" do
      get :index

      response.should be_success
    end

  end

end
