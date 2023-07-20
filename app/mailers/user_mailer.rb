class UserMailer < ApplicationMailer
    def welcome_email(email)
        @code = ValidationCode.find_by_email(email).code
    
        mail(to: email, subject: 'Welcome to My Awesome Site')
      end
end
