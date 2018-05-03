class AnothersController < ApplicationController

  skip_before_action :verify_authenticity_token

  def get_shop
    shop = Shop.find(params[:shop_id])
    if shop
      render json: {
          message: 'success',
          data: {
              shop: shop
          }
      }, status: :ok
    else
      render json: {
          message: 'error',
      }, status: :ok
    end
  end

  def get_invoices
    invoice_ids = params[:invoice_ids].split(', ')
    invoices = Invoice.where(:id => invoice_ids)
    if invoices
      shop_ids = []
      invoices.each do |invoice|
        shop_ids << invoice.shop_id
      end
      shops = Shop.where(:id => shop_ids)
      if shops
        render json: {
            message: 'success',
            data: {
                invoices: invoices,
                shops: shops
            }
        }, status: :ok
      else
        render json: {
            message: 'error with shop',
        }, status: :ok
      end
    else
      render json: {
          message: 'error with shipper',
      }, status: :ok
    end
  end

  def set_invoice
    pars = params.require(:invoice).permit(:shop_id, :shipper_id, :distance, :distance2, :shipping_cost, :deposit, :user_id)
    invoice = Invoice.new(pars)
    if invoice.save
      render json: {
          message: 'success',
      }, status: :ok
    else
      render json: {
          message: 'error',
      }, status: :ok
    end
  end

end
