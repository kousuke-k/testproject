require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  def new_product(image_url)
    Product.new(title: "my book title",
               description: "desc",
               price: 1,
               image_url: image_url)
  end

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end
  # test "the truth" do
  #   assert true
  # end
  test "product prive must be positeve" do
    product = Product.new(title: "my book title",
                         description: "yyy",
                         image_url: "zzz.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')
    
    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')

    product.price = 1
    assert product.valid?
  end
  
  test "image_url" do
    ok = %w{ fred.gif hoge.jpg hoge.png HOGE.JPG HOGE.Jpg http://aaa.co.jp/hoge.gif }
    bad = %w{ hoge.doc hoge.gif/more hoge.gif.more }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid" 
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} should be invalid"
    end
  end
  
  test "product is not valid without a unipue title" do
    product = Product.new(title: products(:ruby).title,
                          description: "yyy",
                          price: 1,
                          image_url: "hoge.gif")
    assert !product.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'), product.errors[:title].join('; ')
  end
  test "title" do
    product = Product.new(title: "short", 
                         description: "desc",
                         price: 1,
                         image_url: "hoge.gif")
    assert product.invalid?
    puts product.errors[:title].join("; ")
  end

end
