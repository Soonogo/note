class UserMailer < ApplicationMailer
    def welcome_email(code)
        @code = code
    
        mail(to: "tttsongen@gmail.com", subject: 'Welcome to My Awesome Site')
      end
end
