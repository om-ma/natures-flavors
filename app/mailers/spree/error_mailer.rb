module Spree
  class ErrorMailer < Spree::BaseMailer

    def order_error_email(order_number, message)
      @message = message
      to_address = Rails.configuration.x.systemerror.email
      subject = "[ERROR - #{Rails.env}] Failed to create Order #: #{order_number} for Route Insurance"
      default_options = Rails.configuration.action_mailer.default_options

      if default_options.nil?
        mail(to: to_address, from: from_address, subject: subject)
      else 
        mail(default_options.merge(to: to_address, from: from_address, subject: subject))
      end
    end

    def update_order_error_email(order_number, message)
      @message = message
      to_address = Rails.configuration.x.systemerror.email
      subject = "[ERROR - #{Rails.env}] Failed to update Order #: #{order_number} for Route Insurance"
      default_options = Rails.configuration.action_mailer.default_options

      if default_options.nil?
        mail(to: to_address, from: from_address, subject: subject)
      else 
        mail(default_options.merge(to: to_address, from: from_address, subject: subject))
      end
    end


    def cancel_order_error_email(order_number, message)
      @message = message
      to_address = Rails.configuration.x.systemerror.email
      subject = "[ERROR - #{Rails.env}] Failed to cancel Order #: #{order_number} for Route Insurance"
      default_options = Rails.configuration.action_mailer.default_options

      if default_options.nil?
        mail(to: to_address, from: from_address, subject: subject)
      else 
        mail(default_options.merge(to: to_address, from: from_address, subject: subject))
      end
    end

    def shipment_error_email(shipment_number, message)
      @message = message
      to_address = Rails.configuration.x.systemerror.email
      subject = "[ERROR - #{Rails.env}] Failed to create Shipment #: #{shipment_number} for Route Insurance"
      default_options = Rails.configuration.action_mailer.default_options

      if default_options.nil?
        mail(to: to_address, from: from_address, subject: subject)
      else 
        mail(default_options.merge(to: to_address, from: from_address, subject: subject))
      end
    end

  end
end