class MembershipsController < ApplicationController
  def show
    @membership = Membership.find(params[:id])
    check_and_mark_notification_as_read
    authorize @membership
  end
end
