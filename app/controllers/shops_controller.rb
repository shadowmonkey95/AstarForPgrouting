class ShopsController < ApplicationController
  def index
    @shops = Shop.all.order("created_at ASC")
  end

  def show
    @shop = Shop.find(params[:id])
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = Shop.new(shop_params)

    if @shop.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
    @shop = Shop.find(params[:id])
    @shop.destroy
    redirect_to root_path
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :address, :lon, :lat)
  end

end
