class RequestsController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_action :authenticate_user!
  before_action :find_shop
  before_action :find_request, except: [:index, :new, :create]

  # load_and_authorize_resource :shop
  load_and_authorize_resource :request, :through => :shop

  def index
    @requests = Request.where({ :shop_id => params[:shop_id]}).all
  end

  def show
    @requests = Request.find(params[:id])
  end

  def new
    @request = @shop.requests.build
  end

  def create
    @request = @shop.requests.build(request_params)

    if @request.save
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
    defaults = { status: 'Pending' }
    params.require(:request).permit(:address, :longitude, :latitude, :comment, :status, :reserve, :deposit).reverse_merge(defaults)
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
