class CustomDeviseMailer < Devise::Mailer
  def confirmation_instructions(record, token, opts = {})
    @token = token
    devise_mail(record, :custom_confirmation_instructions, opts)
  end
end
