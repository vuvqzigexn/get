class UserMailer < ApplicationMailer
  def checkout_email(user)
    @user = user
    byebug
    mail(to: @user.email, subject: 'Checkout Email')
  end
end
