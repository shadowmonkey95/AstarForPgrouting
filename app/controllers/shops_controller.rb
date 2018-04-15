class ShopsController < ApplicationController
  def index
    # @shops = Shop.all.order("created_at ASC")
    @shops_admin = Shop.all
    if user_signed_in?
    @shops = Shop.where(user_id: current_user.id).all
    @hash = Gmaps4rails.build_markers(@shops) do |shop, marker|
      marker.lat shop.latitude
      marker.lng shop.longitude
    end
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

    # respond_to do |format|
    #   if @shop.save
    #     format.html  { redirect_back fallback_location: root_path }
    #   else
    #     format.html  { render 'new' }
    #   end
    # end

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
