module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = :user
      sign_in Factory.create(:user)
    end
  end

  def login_editor
    before(:each) do
      @request.env["devise.mapping"] = :editor
      sign_in Factory.create(:editor)
    end
  end
  
  def user_redirects_to_home
    login_user

    let(:page) { Factory :page }
  
    it "redirects to the home page" do
      get :edit, :id => page.to_param
      response.should redirect_to(root_path)
    end
  end
end
