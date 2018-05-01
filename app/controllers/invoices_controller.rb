class InvoicesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new(invoice_params)
    if @invoice.save
      @invoice.create_activity key: 'invoice.create', recipient: User.where("id = #{@invoice.user_id}").try(:first)
      redirect_to root_path
    else
      render 'new'
    end
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

  private
  def invoice_params
    params.require(:invoice).permit(:shop_id, :shipper_id, :status, :distance, :distance2, :shipping_cost, :deposit, :user_id)
  end
end
