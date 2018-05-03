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
      render json: {
          message: 'success',
          data: {
              invoice_ids: invoices
          }
      }, status: :ok
    else
      render json: {
          message: 'error',
      }, status: :ok
    end
  end

end
