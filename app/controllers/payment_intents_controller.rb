class PaymentIntentsController < ApplicationController
  def index
  end

  def create
    user = User.find(params[:user_id])
    payment_intent = Stripe::PaymentIntent.create({
      amount: Inventory.calculate_payment_amount(params[:items]),
      currency: params[:currency],
      payment_method_types: ENV['PAYMENT_METHODS'] ? ENV['PAYMENT_METHODS'].split(', ') : ['card'],
    }, {
      stripe_account: user.stripe_user_id
    })
    json = {
      paymentIntent: payment_intent
    }

    render json: json
  end

  def shipping_change
    user = User.find(params[:user_id])
    amount = Inventory.calculate_payment_amount(params[:items])
    amount += Inventory.get_shipping_cost(data[:shippingOption][:id])

    payment_intent = Stripe::PaymentIntent.update(
      params[:id],
      {
        amount: amount
      }, {
        stripe_account: user.stripe_user_id
      }
    )

    json = {
      paymentIntent: payment_intent
    }

    rendor json: json
  end

  def status
    payment_intent = Stripe::PaymentIntent.retrieve(params[:id])
    json = {
      paymentIntent: {
        status: payment_intent['status']
      }
    }

    render json: json
  end
end
