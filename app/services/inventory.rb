class Inventory

  def self.calculate_payment_amount(items)
    total = 0
    items.each do |item|
      sku = Stripe::SKU.retrieve(item['parent'])
      total += sku.price * item['quantity']
    end
    total
  end

  def self.get_shipping_cost(id)
    shipping_cost = {
      free: 0,
      express: 500,
    }
    shipping_cost[id.to_sym]
  end

  def self.list_products
    Stripe::Product.list(limit: 3)
  end

  def self.list_skus(product_id)
    Stripe::SKU.list(
      limit: 1,
      product: product_id
      )
  end

  def self.retrieve_product(product_id)
    Stripe::Product.retrieve(product_id)
  end

  def self.products_exist(product_list)
    valid_products = ['increment', 'shirt', 'pins']
    product_list_data = product_list['data']
    products_present = product_list_data.map {|product| product['id']}

    product_list_data.length == 3 && products_present & valid_products == products_present
  end

  def self.create_data
    begin
      products = [
        {
          id: 'increment',
          type: 'good',
          name: 'Increment Magazine',
          attributes: ['issue']
        },
        {
          id: 'pins',
          type: 'good',
          name: 'Stripe Pins',
          attributes: ['set']
        },
        {
          id: 'shirt',
          type: 'good',
          name: 'Stripe Shirt',
          attributes: ['size', 'gender']
        }
      ]

      products.each do |product|
        Stripe::Product.create(product)
      end

      skus = [
        {
          id: 'increment-03',
          product: 'increment',
          attributes: {
            issue: 'Issue #3 “Development”'
          },
          price: 399,
          currency: 'usd',
          inventory: {
            type: 'infinite'
          }
        },
        {
          id: 'shirt-small-woman',
          product: 'shirt',
          attributes: {
            size: 'Small Standard',
            gender: 'Woman'
          },
          price: 999,
          currency: 'usd',
          inventory: {
            type: 'infinite'
          }
        },
        {
          id: 'pins-collector',
          product: 'pins',
          attributes: {
            set: 'Collector Set'
          },
          price: 799,
          currency: 'usd',
          inventory: {
            type: 'finite',
            quantity: 500
          }
        }
      ]

      skus.each do |sku|
        Stripe::SKU.create(sku)
      end

    rescue Stripe::InvalidRequestError => e
      puts "Products already exist, #{e}"
    end
  end
end
