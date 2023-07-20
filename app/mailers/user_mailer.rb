class UserMailer < ApplicationMailer
    def welcome_email(email)
        @code = ValidationCode.order(created_at: :desc).find_by_email(email).code
    
        mail(to: email, subject: 'Welcome to My Awesome Site')
      end
end
