class Api::V1::SessionsController < ApiController
  def create
    @user = User.find_by(email: create_params[:email])
    if @user && @user.valid_password?(create_params[:password])
      sign_in :user, @user
    else
      return api_error(status: 401)
    end
  end

  def api_error(opts = {})
    render nothing: true, status: opts[:status]
  end

  private

  def create_params
    params.require(:user).permit(:email, :password)
  end
end
