require 'faraday'

module RouteAPI
  module V1
    class Client
      include HttpStatusCodes
      include ApiExceptions
      
      API_ENDPOINT = 'https://api.route.com'.freeze

      def quote(public_token, subtotal, currency)
        conn = Faraday.new(
          url: API_ENDPOINT,
          headers: {
            'Content-Type' => 'application/json',
            'token' => public_token
          }
        )

        response = conn.get('/v1/quote') do |req|
          req.params['subtotal'] = subtotal
          req.params['currency'] = currency
        end

        parsed_response = Oj.load(response.body)
        
        return parsed_response if response_successful?(response)

        raise error_class(response, "Method: quote, Code: #{response.status}, response: #{response.body}")
      end

      def create_order(token, order)
        conn = Faraday.new(
          url: API_ENDPOINT,
          headers: {
            'Content-Type' => 'application/json',
            'token' => token
          }
        )

        response = conn.post('/v1/orders') do |req|
          req.body = create_order_hash(order).to_json

          Rails.logger.info req.body
        end

        parsed_response = Oj.load(response.body)

        return parsed_response if response_successful?(response)

        raise error_class(response, "Method: create_order, Code: #{response.status}, response: #{response.body}")
      end

      def update_order(token, order)
        conn = Faraday.new(
          url: API_ENDPOINT,
          headers: {
            'Content-Type' => 'application/json',
            'token' => token
          }
        )

        response = conn.post("/v1/orders/#{order.number}") do |req|
          req.body = update_order_hash(order).to_json
        end

        parsed_response = Oj.load(response.body)

        return parsed_response if response_successful?(response)

        raise error_class(response, "Method: update_order, Code: #{response.status}, response: #{response.body}")
      end

      def cancel_order(token, order)
        conn = Faraday.new(
          url: API_ENDPOINT,
          headers: {
            'Content-Type' => 'application/json',
            'token' => token
          }
        )

        response = conn.post("/v1/orders/#{order.number}/cancel")

        parsed_response = Oj.load(response.body)

        return parsed_response if response_successful?(response)

        raise error_class(response, "Method: cancel_order, Code: #{response.status}, response: #{response.body}")
      end

      def create_shipment(token, shipment)
        conn = Faraday.new(
          url: API_ENDPOINT,
          headers: {
            'Content-Type' => 'application/json',
            'token' => token
          }
        )

        response = conn.post('/v1/shipments') do |req|
          req.body = create_shipment_hash(shipment).to_json

          Rails.logger.info req.body
        end
        
        parsed_response = Oj.load(response.body)

        return parsed_response if response_successful?(response)

        raise error_class(response, "Method: create_shipment, Code: #{response.status}, response: #{response.body}")
      end

      private      

      def error_class(response, message)
        case response.status
        when HTTP_BAD_REQUEST_CODE
          BadRequestError.new(message)
        when HTTP_UNAUTHORIZED_CODE
          UnauthorizedError.new(message)
        when HTTP_FORBIDDEN_CODE
          ForbiddenError.new(message)
        when HTTP_NOT_FOUND_CODE
          NotFoundError.new(message)
        when HTTP_UNPROCESSABLE_ENTITY_CODE
          UnprocessableEntityError.new(message)
        else
          ApiError.new(message)
        end
      end

      def response_successful?(response)
        response.status == HTTP_OK_CODE || response.status == HTTP_OK_CODE_201 || response.status == HTTP_OK_CODE_204
      end

      def create_order_hash(order)
        {
          source_order_id: order.number,
          subtotal: order.item_total,
          order_total: order.total,
          shipping_total: order.shipment_total,
          discounts_total: order.adjustment_total,
          taxes: order.tax_total,
          currency: order.currency,
          insurance_selected: order.route_insurance_selected,
          customer_details: {
            first_name: order.ship_address.first_name,
            last_name: order.ship_address.last_name,
            email: order.email
            },
          shipping_details: {
            first_name: order.ship_address.first_name,
            last_name: order.ship_address.last_name,
            street_address1: order.ship_address.address1,
            street_address2: check_null(order.ship_address.address2),
            city: order.ship_address.city,
            province: check_null(order.ship_address.state_text),
            country_code: order.ship_address.country.iso,
            zip: order.ship_address.zipcode
            },
          line_items: line_items_hash(order),
          source_created_on: order.completed_at.iso8601,
          source_updated_on: order.updated_at.iso8601
        }
      end

      def update_order_hash(order)
        {
          source_order_id: order.number,
          subtotal: order.item_total,
          order_total: order.total,
          shipping_total: order.shipment_total,
          discounts_total: order.adjustment_total,
          taxes: order.tax_total,
          currency: order.currency,
          insurance_selected: order.route_insurance_selected,
          shipping_details: {
            first_name: order.ship_address.first_name,
            last_name: order.ship_address.last_name,
            street_address1: order.ship_address.address1,
            street_address2: check_null(order.ship_address.address2),
            city: order.ship_address.city,
            province: check_null(order.ship_address.state_text),
            country_code: order.ship_address.country.iso,
            zip: order.ship_address.zipcode
            },
          line_items: line_items_hash(order),
          source_created_on: order.completed_at.iso8601,
          source_updated_on: order.updated_at.iso8601
        }
      end

      def line_items_hash(order)
        order.line_items.map do |item|
          line_item_hash(item)
        end
      end

      def line_item_hash(item)
        {
          source_product_id: item.variant.id.to_s,
          source_id: item.id.to_s,
          sku: item.variant.sku,
          name: item.name,
          price: item.price,
          quantity: item.quantity,
          image_url: product_image(item)
        }
      end

      def product_image(item)
        if item.variant.images.length == 0
          product_image = item.variant.product.images.first.my_cf_image_url("large")
        else
          product_image = item.variant.images.first.my_cf_image_url("large")
        end
      end

      def check_null(val)
        return '' if val == nil
        return val
      end

      def create_shipment_hash(shipment)
        {
          tracking_number: shipment.tracking,
          source_order_id: shipment.order.number,
          source_product_ids: shipment_product_ids_hash(shipment),
          courier_id: shipment_courier_id(shipment),
          line_items: shipment_line_items_hash(shipment)
        }
      end

      def shipment_product_ids_hash(shipment)
        shipment.line_items.map do |item|
          item.variant.id.to_s
        end
      end

      def shipment_courier_id(shipment)
        selected_rate = shipment.shipping_rates.select { |rate| rate.selected }
        if selected_rate.count > 0
          get_courier_id_from_shipping_method_name(selected_rate[0].shipping_method.name)
        else
          ''
        end
      end

      def get_courier_id_from_shipping_method_name(name)
        if name.include?('FedEx')
          return 'fedex'
        elsif name.include?('UPS')
          return 'ups'
        elsif name.include?('USPS')
          return 'usps'
        else
          return name
        end
      end

      def shipment_line_items_hash(shipment)
        shipment.line_items.map do |item|
          shipment_line_item_hash(item)
        end
      end

      def shipment_line_item_hash(item)
        {
          source_product_id: item.variant.id.to_s,
          source_id: item.id.to_s,
          sku: item.variant.sku,
          name: item.name,
          price: item.price,
          quantity: item.quantity,
          image_url: product_image(item)
        }
      end

    end
  end
end
