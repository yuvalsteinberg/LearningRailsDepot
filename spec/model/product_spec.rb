require "spec_helper"

describe Product do

  describe 'demo tests' do
    it "product attributes must not be empty" do
      product = Product.new
      product.should_not be_valid
      product.error_on(:name).should be_true
      product.error_on(:title).should be_true
      product.error_on(:description).should be_true
      product.error_on(:price).should be_true
      product.error_on(:image_url).should be_true
    end

    it "price must be positive" do
      product = new_product("zzz.gif")
      product.price = -1
      product.should_not be_valid
      product.errors[:price].join('; ').should eq "must be greater than or equal to 0.01"

      product.price = 0
      product.should_not be_valid
      product.errors[:price].join('; ').should eq "must be greater than or equal to 0.01"

      product.price = 1
      product.should be_valid
    end

    it "image url" do
      ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
      bad = %w{ fred.doc fred.gif/more fred.gif.more }

      ok.each do |name|
        new_product(name).should be_valid, "#{name} shouldn't be invalid"
      end

      bad.each do |name|
        new_product(name).should_not be_valid, "#{name} shouldn't be invalid"
      end
    end

    it "product is not valid without a uniuqe title" do
      product1 = new_product("a.gif")
      product2 = new_product("b.gif")
      product1.save

      product2.should_not be_valid, "product should be invalid"
      product2.save.should be_false, "Save should have failed"
      I18n.translate('activerecord.errors.messages.taken').should eq product2.errors[:title].join('; ')
    end

    def new_product(image_url)
      product = Product.new(title: "My book title", description: "Test description", image_url: image_url, price: 1)
    end

  end

end
