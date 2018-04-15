class ShopsController < ApplicationController
  def index
    # @shops = Shop.all.order("created_at ASC")
    @shops_admin = Shop.all
    if user_signed_in?
    @shops = Shop.where(user_id: current_user.id).all
    end
  end

  def show
    @shop = Shop.find(params[:id])
  end

  def new
    @shop = current_user.shops.build
  end

  def create
    @shop = current_user.shops.build(shop_params)

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
    params.require(:shop).permit(:name, :address, :longitude, :latitude)
  end

end
