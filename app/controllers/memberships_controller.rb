class MembershipsController < ApplicationController
  def show
    @membership = Membership.find(params[:id])
    check_and_mark_notification_as_read if params[:notification_id]
    authorize @membership
  end
end
