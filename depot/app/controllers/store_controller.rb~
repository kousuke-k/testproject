class StoreController < ApplicationController
  def index
    @products = Product.order(:title)
    @count = count_increment
  end

end
