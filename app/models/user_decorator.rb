module Spree
  module UserDecorator
  
    def self.prepended(base)
      base.validates :password,
        format: { with: /\A(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d][^ ]{7,}\z/,
                  message: 'must contain at least 7 characters, including at least 1 letter and 1 number.'
                 }, if: :check_password?
    end

    def check_password?
      if persisted?
        changed_attributes.include?("password_salt")
      else
        password_required?
      end
    end
  
    def password_required?
      !persisted? || !password.nil? || !password_confirmation.nil?
    end    
  
  end
end
::Spree::User.prepend(Spree::UserDecorator)