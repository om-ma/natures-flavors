module Spree
  module OrderDecorator

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
      save!
      updater.run_hooks

      touch :completed_at

      unless confirmation_delivered?
        deliver_order_confirmation_email

        # OVERRIDE: custom code to email documents for automatic printing
        if Rails.configuration.x.backoffice.print_docs
          deliver_backoffice_invoice_email
          deliver_backoffice_pick_list_email
          deliver_backoffice_packing_list_email
        end
      end

      deliver_store_owner_order_notification_email if deliver_store_owner_order_notification_email?

      consider_risk
    end

    def confirmation_required?
      Spree::Config[:always_include_confirm_step]
    end

    private

    def deliver_backoffice_invoice_email
      Spree::InvoiceMailer.invoice_email(self).deliver_later
    end

    def deliver_backoffice_pick_list_email
      Spree::InvoiceMailer.pick_list_email(self).deliver_later
    end

    def deliver_backoffice_packing_list_email
      Spree::InvoiceMailer.packing_list_email(self).deliver_later
    end

  end
end

::Spree::Order.prepend(Spree::OrderDecorator)