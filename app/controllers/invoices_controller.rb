class InvoicesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new(invoice_params)
    if @invoice.save
      # @invoice.create_activity key: 'invoice.create', recipient: User.where("id = #{@invoice.user_id}").try(:first)
      redirect_to root_path
    else
      render 'new'
    end
  end

  def index
    @invoices = Invoice.where(:user_id => current_user.id, read_at: nil).reverse
  end

  def show
    invoice = Invoice.find_by_id(params[:id])
    render json: {
        message: 'success',
        data: {
          invoice: invoice
        }
    }, status: :ok
  end

  def mark_as_read
    @invoices = Invoice.where(:user_id => current_user.id, read_at: nil)
    @invoices.update_all(read_at: Time.zone.now)
    render json: {success: true}
  end

  def create_invoice
    pars = params.require(:invoice).permit(:shop_id, :shipper_id, :distance, :shipping_cost, :deposit)
    invoice = Invoice.new(pars)
    if invoice.save
      render json: {
          message: 'success',
          data: {
            invoice: invoice
          }
      }, status: :ok
    else
      render json: {
          message: 'error',
      }, status: :ok
    end
  end

  def shipper_get_invoices
    shipper_id = params[:shipper_id]
    invoices = Invoice.where(shipper_id: shipper_id)
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

  protected
  def json_request?
    request.format.json?
  end

  private
  def invoice_params
    params.require(:invoice).permit(:shop_id, :shipper_id, :status, :distance, :distance2, :shipping_cost, :deposit, :user_id)
  end

end
