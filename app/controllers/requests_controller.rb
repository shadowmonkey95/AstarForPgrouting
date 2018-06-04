class RequestsController < ApplicationController

  include Matching

  helper_method :sort_column, :sort_direction

  before_action :authenticate_user!, :invoice_notification
  before_action :find_shop, except: [:user_requests]
  before_action :find_request, except: [:index, :new, :create, :user_requests]

  # load_and_authorize_resource :shop
  load_and_authorize_resource :request, :through => :shop

  def index
    # @requests = Request.where(["shop_id = ? and status = ?", @shop.id, "Pending"])
    # Request.where(["shop_id = ? and status in(?,?)", params[:shop_id], "Pending", "Processing"])
    @requests = Request.order(sort_column + " " + sort_direction).where({ :shop_id => params[:shop_id]}).page(params[:requests]).per(6)
    @requests_count = Request.where({ :shop_id => params[:shop_id]}).count

    # @requests_pending = Request.order(sort_column + " " + sort_direction).where({ :shop_id => params[:shop_id], :status => "Pending"}).page(params[:requests_pending]).per(6)
    # @requests_pending_count = Request.where({ :shop_id => params[:shop_id], :status => "Pending"}).count
    @requests_pending = Request.order(sort_column + " " + sort_direction).where(["shop_id = ? and status in(?,?)", params[:shop_id], "Pending", "Processing"]).page(params[:requests_pending]).per(6)
    @requests_pending_count = Request.where(["shop_id = ? and status in(?,?)", params[:shop_id], "Pending", "Processing"]).count

    # @requests_found = Request.order(sort_column + " " + sort_direction).where({ :shop_id => params[:shop_id], :status => "Found shipper"}).page(params[:requests_found]).per(6)
    # @requests_found_count = Request.where({ :shop_id => params[:shop_id], :status => "Found shipper"}).count
    @requests_found = Request.order(sort_column + " " + sort_direction).where(["shop_id = ? and status in(?,?,?)", params[:shop_id], "Found shipper", "Shipper arrived", "Completed"]).page(params[:requests_found]).per(6)
    @requests_found_count = Request.where(["shop_id = ? and status in(?,?,?)", params[:shop_id], "Found shipper", "Shipper arrived", "Completed"]).count
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
    @request = Request.find(params[:id])
    @hash = Gmaps4rails.build_markers(@request) do |request, marker|
      marker.lat request.latitude
      marker.lng request.longitude
      marker.infowindow "Delivery Location </br> Address: #{request.address} "
    end
    @hash2 = Gmaps4rails.build_markers(@shop) do |shop, marker|
      marker.lat shop.latitude
      marker.lng shop.longitude
      marker.infowindow "Shop's name: #{shop.name} </br> Address: #{shop.address} "
    end
  end

  def new
    @request = @shop.requests.build
  end

  def create
    @request = @shop.requests.build(request_params)
    # @has_reserve = Request.select(:has_reserve).distinct
    # @request.update_columns(Time.zone.now)
    # @request.status = "Pending"
    if (@request.has_reserve == 0)
      @request.status = "Processing"
    else
      @request.status = "Pending"
    end
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
    Request.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
