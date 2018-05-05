class AnothersController < ApplicationController

  include Matching

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
      shops = []
      invoices.each do |invoice|
        shop = Shop.find(invoice.shop_id)
        if shop
          shops << shop
        end
      end
      render json: {
          message: 'success',
          data: {
              invoices: invoices,
              shops: shops
          }
      }, status: :ok
    else
      render json: {
          message: 'error',
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

  def set_shipper_status
    id = params[:id]
    status = params[:status]
    shipper = Shipper.find_by_id(id)
    if shipper
      shipper.status = status
      shipper.save
      render json: {
        message: 'success',
      }, status: :ok
    else
      render json: {
        message: 'error',
      }, status: :ok
    end
  end

  def cancel_booking
    shipper_id = params[:shipper_id]
    invoice_id = params[:invoice_id]
    availables = Available.find_by(invoice_id: invoice_id)
    available = availables.shipper_id.split(', ')
    next_shipper = 0
    (0..available.count - 1).each do |i|
      if shipper_id == available[i].to_i
        next_shipper = available[i + 1]
      end
    end
    if next_shipper
      # shipper = Shipper.find(next_shipper)
      # invoice = Invoice.find_by_id(invoice_id)
      # shop = Shop.find_by_id(invoice.shop_id)
      # location = Location.find_by(shipper_id: next_shipper)
      # distance = Haversine.distance(shop.latitude.to_f, shop.longitude.to_f, location.latitude.to_f, location.longtitude.to_f).to_m
      # invoice.shipper_id = next_shipper
      # invoice.distance = distance
      # invoice.distance2 = distance
      # invoice.shipping_cost = MatchingClass.shippingCost(distance)
      # invoice.save
      #
      # # MatchingClass.set_path(invoice.shop_id, next_shipper)
      # sendNoti(shipper.req_id, invoice.id)

      render json: {
        message: 'success',
        data: {
          next_shipper: next_shipper
        }
      }, status: :ok
    end
  end

end
