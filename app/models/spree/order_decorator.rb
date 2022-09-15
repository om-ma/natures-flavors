Spree::Order.class_eval do

    # Set by admin/order_controller to be used to log state change for production state
    attr_accessor :current_user

    # Update production state
    PRODUCTION_STATES = %w(ready processing follow_up_requested production_room in_labels in_qc complete canceled)

    validates :production_state,       inclusion:    { in: PRODUCTION_STATES, allow_blank: true }

    # Hack to get constant
    def self.get_production_states
      const_get("PRODUCTION_STATES")
    end

    # Finalizes an in progress order after checkout is complete.
    # Called after transition to complete state when payments will have been processed
    #
    # DTL
    # OVERRIDE to
    # - email documents, i.e. invoice, packing list, picking list, for automatic printing
    def finalize!
      # lock all adjustments (coupon promotions, etc.)
      all_adjustments.each(&:close)

      # update payment and shipment(s) states, and save
      updater.update_payment_state
      shipments.each do |shipment|
        shipment.update!(self)
        shipment.finalize!
      end

      updater.update_shipment_state

      # update production state
      updater.update_production_state

      save!
      updater.run_hooks

      touch :completed_at

      unless confirmation_delivered?
        deliver_order_confirmation_email

        # OVERRIDE: custom code to email documents for automatic printing
        if Rails.configuration.x.backoffice.print_docs
          deliver_backoffice_invoice_email
          deliver_backoffice_pick_list_email
        end
      end

      deliver_store_owner_order_notification_email if deliver_store_owner_order_notification_email?

      consider_risk
    end

    # This does not work. Conflicts with ApplePayOrderDecorator in spree_gateway. 
    # See app/models/spree_gateway/apple_pay_order_decorator.rb for override to spree_gateway
    def confirmation_required?
      Spree::Config[:always_include_confirm_step]
    end
    
    def deliver_backoffice_invoice_email
      Spree::InvoiceMailer.invoice_email(self).deliver_later
    end

    def deliver_backoffice_pick_list_email
      Spree::InvoiceMailer.pick_list_email(self).deliver_later
    end

    def deliver_backoffice_packing_list_email
      Spree::InvoiceMailer.packing_list_email(self).deliver_later
    end

    def state_changed(name)
      changed_by_user_id = user_id
      if name == 'production' && !current_user.nil?
        changed_by_user_id = current_user.id
      end

      state = "#{name}_state"
      if persisted?
        old_state = send("#{state}_was")
        new_state = send(state)
        unless old_state == new_state
          state_changes.create(
            previous_state: old_state,
            next_state:     new_state,
            name:           name,
            user_id:        changed_by_user_id
          )
        end
      end
    end

end