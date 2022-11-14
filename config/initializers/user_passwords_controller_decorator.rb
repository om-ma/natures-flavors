module Spree
  UserPasswordsController.class_eval do

    # Override for recaptcha
    def create
      success = verify_recaptcha(action: 'recover', minimum_score: 0.5, secret_key: ENV['RECAPTCHA_SECRET_KEY_V3'])
      checkbox_success = verify_recaptcha unless success

      if success || checkbox_success
        self.resource = resource_class.send_reset_password_instructions(params[resource_name], current_store)

        if resource.errors.empty?
          set_flash_message(:notice, :send_instructions) if is_navigational_format?
          respond_with resource, location: spree.login_path
        else
          respond_with_navigational(resource) { render :new }
        end
      else
        if !success
          @show_checkbox_recaptcha = true
        end
        render :new
      end

    end

  end
end
