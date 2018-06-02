class RequestsController < ApplicationController

  include Matching

  helper_method :sort_column, :sort_direction

  before_action :authenticate_user!, :invoice_notification
  before_action :find_shop, except: [:user_requests]
  before_action :find_request, except: [:index, :new, :create, :user_requests]

  # load_and_authorize_resource :shop
  load_and_authorize_resource :request, :through => :shop

  def index
    @requests = Request.where({ :shop_id => params[:shop_id]}).page(params[:requests]).per(6)
    @requests_count = Request.where({ :shop_id => params[:shop_id]}).count

    @requests_pending = Request.where({ :shop_id => params[:shop_id], :status => "Pending"}).page(params[:requests_pending]).per(6)
    @requests_pending_count = Request.where({ :shop_id => params[:shop_id], :status => "Pending"}).count

    @requests_found = Request.where({ :shop_id => params[:shop_id], :status => "Found shipper"}).page(params[:requests_found]).per(6)
    @requests_found_count = Request.where({ :shop_id => params[:shop_id], :status => "Found shipper"}).count
  end

  # def user_requests
  #     @shops = Shop.where({ :user_id => current_user.id})
  #     @requests = Request.where("shop_id IN (?)", @shops)
  # end

  # if (params[:shop_id] != nil)
  #   @shop = Shop.find(params[:shop_id])
  #   @requests = Request.where({ :shop_id => params[:shop_id]}).page(params[:page]).per(8)
  # else
  #   @shops = Shop.where({ :user_id => current_user.id})
  #   @requests = Request.where("shop_id IN (?)", @shops)
  # end

  def show
    @requests = Request.find(params[:id])
  end

  def new
    @request = @shop.requests.build
  end

  def create
    @request = @shop.requests.build(request_params)
    # @has_reserve = Request.select(:has_reserve).distinct
    # @request.update_columns(Time.zone.now)
    @request.status = "Pending"
    if (@request.reserve <= Time.zone.now)
      @request.reserve = Time.zone.now
    end
    if @request.save
      if @request.has_reserve == 0
        File.open("requests.txt",'a+') do |filea|
          filea.puts @request.id
        end
      end
      redirect_to user_shop_requests_path(@shop)
    else
      render 'new'
    end
  end

  def destroy
    @request = Request.find(params[:id])
    @request.destroy
    redirect_to user_shop_requests_path
  end

  def edit
    # @request = Request.find(params[:id])
  end

  def update
    if @request.update(request_params)
      redirect_to user_shop_requests_path(@shop)
    else
      render 'edit'
    end

  end

  private
  def request_params
    params.require(:request).permit(:address, :longitude, :latitude, :comment, :status, :reserve, :deposit, :has_reserve)
  end

  def invoice_notification
    @invoices = Invoice.where(:user_id => current_user.id, read_at: nil).reverse
  end

  def find_shop
    @shop = Shop.find(params[:shop_id])
  end

  def find_request
    @request = Request.find(params[:id])
  end

  def sort_column
    Shop.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
