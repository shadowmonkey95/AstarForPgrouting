class MainController < ApplicationController
  def index
  end

  # def search
  #   @shops = Shop.ransack(user_id_in: [current_user.id], name_cont: params[:q]).result(distinct: true)
  #   @requests = Request.ransack(user_id_in: [current_user.id], name_cont: params[:q]).result(distinct: true)
  #
  #   respond_to do |format|
  #     format.html {}
  #     format.json {
  #       @shops = @shops.limit(5)
  #       @requests = @requests.limit(5)
  #     }
  #   end
  # end

  def search
    @invoices = Invoice.where(:user_id => current_user.id, read_at: nil).reverse
    if current_user.has_role? :admin
      @shops = Shop.ransack(name_cont: params[:q]).result(distinct: true)
      @requests = Request.ransack(name_cont: params[:q]).result(distinct: true)

      respond_to do |format|
        format.html {}
        format.json {
          @shops = @shops.limit(5)
          @requests = @requests.limit(5)
        }
      end
    else
      @shops = Shop.ransack(user_id_in: [current_user.id], name_cont: params[:q]).result(distinct: true)
      @requests = Request.ransack(user_id_in: [current_user.id], name_cont: params[:q]).result(distinct: true)

      respond_to do |format|
        format.html {}
        format.json {
          @shops = @shops.limit(5)
          @requests = @requests.limit(5)
        }
      end
    end

  end
end
