class ShopsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!
  load_and_authorize_resource :through => :current_user
  def index
    # @shops = Shop.all.order("created_at ASC")
    # @shops_admin = Shop.all
    @shops_admin = Shop.order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])
      if user_signed_in?
      @shops = Shop.where(user_id: current_user.id).paginate(:per_page => 5, :page => params[:page]).order(sort_column + " " + sort_direction)
      @hash = Gmaps4rails.build_markers(@shops) do |shop, marker|
        marker.lat shop.latitude
        marker.lng shop.longitude
        marker.infowindow "Name: #{shop.name} </br> Address: #{shop.address} "
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
      flash[:notice] = "Shop successfully created"
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

  def sort_column
    Shop.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
