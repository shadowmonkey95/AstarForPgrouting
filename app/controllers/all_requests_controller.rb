class AllRequestsController < ApplicationController

  helper_method :sort_column, :sort_direction

  before_action :authenticate_user!, :invoice_notification

  def requests
    @invoices = Invoice.where(:user_id => current_user.id, read_at: nil).reverse
    @shops = Shop.where({ :user_id => current_user.id}).ids
    # @requests = Request.where("shop_id IN (?)", @shops)

    @requests = Request.where("shop_id IN (?)", @shops).page(params[:requests]).per(8)
    @requests_count = Request.where("shop_id IN (?)", @shops).count

    @requests_pending = Request.where("shop_id IN (?) AND status = ?", @shops, "Pending").page(params[:requests_pending]).per(8)
    @requests_pending_count = Request.where("shop_id IN (?) AND status = ?", @shops, "Pending").count

    @requests_found = Request.where("shop_id IN (?) AND status = ?", @shops, "Found shipper").page(params[:requests_found]).per(8)
    @requests_found_count = Request.where("shop_id IN (?) AND status = ?", @shops, "Found shipper").count
  end

  def requests_destroy
    @request = Request.find(params[:id])
    @request.destroy
    redirect_to requests_path
  end

  private

  def invoice_notification
    @invoices = Invoice.where(:user_id => current_user.id, read_at: nil).reverse
  end


  def sort_column
    Shop.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
