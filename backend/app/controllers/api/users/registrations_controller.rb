class Api::Users::RegistrationsController < Devise::RegistrationsController
  def create
    if user_params[:password] != user_params[:password_confirmation]
      render json: {
        errors: [ "Password confirmation error" ]
      }, status: :unprocessable_entity
    else
      user = User.new(user_params)
      user.jti = SecureRandom.uuid

      if user.save
        render json: {
          user: user.json_representation,
          message: "We have sent you a confirmation email. Please check your email."
        }, status: :created
      else
        render json: {
          errors: user.errors.full_messages
        }, status: :unprocessable_entity
      end

    end
  end

  private

  def user_params
    params.require(:registration).permit(:name, :email, :password, :password_confirmation)
  end
end
