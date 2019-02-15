require 'rails_helper'

describe 'User will not see any leagues that do not have an approved membership', type: :feature do
  let(:pending_league) { Membership.where(user: user, status: :pending) }
  let(:rejected_league) { Membership.where(user: user, status: :rejected) }

  before do
    create(:membership, status: :pending, user: user, role: 0)
    create(:membership, status: :rejected, user: user, role: 0)
    stub_current_user user
    visit dashboard_path
  end

  describe 'As a user who is only a member' do
    let(:user) { create(:user) }


    it 'will not have any leagues with a pending/rejected status' do
      expect(page).not_to have_content(pending_league.name)
      expect(page).not_to have_content(rejected_league.name)
    end
  end

  describe 'As a user who is an admin for another league' do
    let(:league) { create(:league) }
    let(:user) { league.user }

    it 'will not have any leagues with a pending/rejected status' do
      expect(page).to have_content(league.name)
      expect(page).not_to have_content(pending_league.name)
      expect(page).not_to have_content(rejected_league.name)
    end
  end
end
