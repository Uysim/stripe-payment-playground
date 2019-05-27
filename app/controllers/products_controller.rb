class ProductsController < ApplicationController
  def index
    products = Inventory.list_products
    if Inventory.products_exist(products)
      render json: products
    else
      # Setup products
      puts "Needs to setup products"
      Inventory.create_data
      products = Inventory.list_products
      render json: products
    end
  end

  def show
    render json: Inventory.retrieve_product(params[:id])
  end

  def skus
    render json: Inventory.list_skus(params[:id])
  end
end
