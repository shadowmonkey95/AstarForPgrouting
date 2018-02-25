class RequestsController < ApplicationController
  before_action :find_shop
  before_action :find_request, except: [:index, :new, :create]

  def index
    @requests = Request.where({ :shop_id => params[:shop_id]}).all
  end

  def new
    @request = Request.new
  end

  def create
    @request = Request.new(request_params)

    if @request.save!
      redirect_to shop_requests_path(@shop)
    else
      render 'new'
    end
  end

  def destroy
    @request = Request.find(params[:id])
    @request.destroy
    redirect_to shop_requests_path
  end

  def edit
    # @request = Request.find(params[:id])
  end

  def update
    if @request.update(request_params)
      redirect_to shop_requests_path(@shop)
    else
      render 'edit'
    end

  end

  private
  def request_params
    defaults = { status: 'Pending', shop_id: params[:shop_id]  }
    params.require(:request).permit(:destination_address, :status, :shop_id).reverse_merge(defaults)
  end

  def find_shop
    @shop = Shop.find(params[:shop_id])
  end

  def find_request
    @request = Request.find(params[:id])
  end
end
