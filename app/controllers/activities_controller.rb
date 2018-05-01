class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, if: :json_request?

  def index
    @activities = PublicActivity::Activity.order("created_at desc").where(recipient_id: current_user, recipient_type: "User", read_at: nil)
  end

  def mark_as_read
    @activities = PublicActivity::Activity.order("created_at desc").where(recipient_id: current_user, recipient_type: "User", read_at: nil)
    @activities.update_all(read_at: Time.zone.now)
    render json: {success: true}
  end

  protected

  def json_request?
    request.format.json?
  end
end
