class MembershipsController < ApplicationController
  def show
    @membership = Membership.find(params[:id])
    check_and_mark_notification_as_read
    authorize @membership
  end

  def create
    membership = league.memberships.new(membership_requestor_params)
    if membership.save
    else
    end
    redirect_to request.referer
  end

  private

  def membership_requestor_params
    membership_params.merge(requestor_id: current_user.id)
  end

  def membership_params
    params.require(:membership).permit(:league_id, :user_id)
  end

  def league
    @league ||= League.find(membership_params[:league_id])
  end
end
