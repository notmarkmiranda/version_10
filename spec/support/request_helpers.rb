def stub_current_user(user=nil)
  user = create(:user) if user.nil?
  allow_any_instance_of(ApplicationController)
    .to receive(:current_user)
    .and_return(user)
end
