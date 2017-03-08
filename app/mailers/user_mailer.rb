class UserMailer < ApplicationMailer
  default from: 'vyquocvu@gmail.com'
  def checkout_email(order)
    @order = order
    mail(to: order.email, subject: 'Checkout Email')
  end
end
