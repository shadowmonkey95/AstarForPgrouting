class ShopsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!, :invoice_notification
  load_and_authorize_resource :through => :current_user
  def index
    # @shops = Shop.all.order("created_at ASC")
    # @shops_admin = Shop.all
    @shops_admin = Shop.order(sort_column + " " + sort_direction).page(params[:page]).per(5)
      if user_signed_in?
      @shops = Shop.where(user_id: current_user.id).order(sort_column + " " + sort_direction).page(params[:page]).per(5)
      @hash = Gmaps4rails.build_markers(@shops) do |shop, marker|
        marker.lat shop.latitude
        marker.lng shop.longitude
        marker.infowindow "Name: #{shop.name} </br> Address: #{shop.address} "
      end
    end
  end

  def show
    @shop = Shop.find(params[:id])
    @hash = Gmaps4rails.build_markers(@shop) do |shop, marker|
      marker.lat shop.latitude
      marker.lng shop.longitude
      marker.infowindow "Name: #{shop.name} </br> Address: #{shop.address} "
    end
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
    @requests = Request.where(["shop_id = ? and status = ?", @shop.id, "Pending"])
    if @requests.empty?
      @shop.destroy
      redirect_to root_path
    else
      flash.alert = "Cannot delete"
      redirect_to root_path
    end
    # @shop.destroy
    # redirect_to root_path
  end

  private
  def invoice_notification
    @invoices = Invoice.where(:user_id => current_user.id, read_at: nil).reverse
  end

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
