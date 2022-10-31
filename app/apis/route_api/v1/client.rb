require 'faraday'

module RouteAPI
  module V1
    class Client
      include HttpStatusCodes
      include ApiExceptions
      
      API_ENDPOINT = 'https://api.route.com'.freeze

      def quote(merchant_id, public_token, cart)
        stock_location = Spree::StockLocation.where(active: true).first
        
        conn = Faraday.new(
          url: API_ENDPOINT,
          headers: {
            'Content-Type' => 'application/json',
            'token' => public_token
          }
        )

        response = conn.post('/v2/quotes') do |req|
          req.body = quote_hash(merchant_id, cart, stock_location).to_json
        end

        parsed_response = Oj.load(response.body)
        
        return parsed_response if response_successful?(response)

        raise error_class(response, "Method: quote, Code: #{response.status}, response: #{response.body}")
      end

      def create_order(token, order)
        stock_location = Spree::StockLocation.where(active: true).first
        
        conn = Faraday.new(
          url: API_ENDPOINT,
          headers: {
            'Content-Type' => 'application/json',
            'token' => token
          }
        )

        response = conn.post('/v2/orders') do |req|
          req.body = create_order_hash(order, stock_location).to_json
        end

        parsed_response = Oj.load(response.body)

        return parsed_response if response_successful?(response)

        raise error_class(response, "Method: create_order, Code: #{response.status}, response: #{response.body}")
      end

      def update_order(token, order)
        stock_location = Spree::StockLocation.where(active: true).first
        
        conn = Faraday.new(
          url: API_ENDPOINT,
          headers: {
            'Content-Type' => 'application/json',
            'token' => token
          }
        )

        response = conn.post("/v2/orders/#{order.number}") do |req|
          req.body = update_order_hash(order, stock_location).to_json
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

      def quote_hash(merchant_id, cart, stock_location)
        {
          merchant_id: merchant_id,
          cart: {
            cart_ref: cart.number,
            covered: {
              currency: cart.currency,
              amount: cart.item_total,
            },
            cart_item: line_items_hash(cart, stock_location)
          }
        }
      end

      def cart_line_items_hash(cart)
        cart.line_items.map do |item|
          cart_line_item_hash(item)
        end
      end

      def cart_line_item_hash(item)
        {
          id: item.variant.id.to_s,
          unit_price: item.price,
          quantity: item.quantity
        }
      end

      def create_order_hash(order, stock_location)
        {
          source_order_id: order.number,
          source_order_number: order.number,
          subtotal: order.item_total,
          order_total: order.total,
          shipping_total: order.shipment_total,
          discounts_total: order.adjustment_total,
          taxes: order.tax_total,
          currency: order.currency,
          paid_to_insure: (order.route_insurance_selected ? order.route_insurance_price : 0.00),
          insurance_selected: order.route_insurance_selected,
          customer_details: {
            first_name: order.ship_address.first_name,
            last_name: order.ship_address.last_name,
            email: order.email,
            phone: check_null(order.ship_address.phone)
            },
          shipping_details: {
            first_name: order.ship_address.first_name,
            last_name: order.ship_address.last_name,
            street_address1: order.ship_address.address1,
            street_address2: check_null(order.ship_address.address2),
            city: order.ship_address.city,
            province: check_null(order.ship_address.state_text),
            country_code: order.ship_address.country.iso,
            zip: order.ship_address.zipcode,
            phone: check_null(order.ship_address.phone)
            },
          line_items: line_items_hash(order, stock_location),
          cart_ref: order.number,
          quote_id: order.route_insurance_quote_id,
          source_created_on: order.completed_at.iso8601,
          source_updated_on: order.updated_at.iso8601
        }
      end

      def update_order_hash(order, stock_location)
        {
          source_order_id: order.number,
          source_order_number: order.number,
          subtotal: order.item_total,
          order_total: order.total,
          shipping_total: order.shipment_total,
          discounts_total: order.adjustment_total,
          taxes: order.tax_total,
          currency: order.currency,
          paid_to_insure: (order.route_insurance_selected ? order.route_insurance_price : 0.00),
          insurance_selected: order.route_insurance_selected,
          customer_details: {
            first_name: order.ship_address.first_name,
            last_name: order.ship_address.last_name,
            email: order.email,
            phone: check_null(order.ship_address.phone)
            },
          shipping_details: {
            first_name: order.ship_address.first_name,
            last_name: order.ship_address.last_name,
            street_address1: order.ship_address.address1,
            street_address2: check_null(order.ship_address.address2),
            city: order.ship_address.city,
            province: check_null(order.ship_address.state_text),
            country_code: order.ship_address.country.iso,
            zip: order.ship_address.zipcode,
            phone: check_null(order.ship_address.phone)
            },
          line_items: line_items_hash(order, stock_location),
          cart_ref: order.number,
          quote_id: order.route_insurance_quote_id,
          source_created_on: order.completed_at.iso8601,
          source_updated_on: order.updated_at.iso8601
        }
      end

      def line_items_hash(order, stock_location)
        order.line_items.map do |item|
          line_item_hash(order, item, stock_location)
        end
      end

      def line_item_hash(order, item, stock_location)
        {
          id: item.id,
          source_id: item.id.to_s,
          source_product_id: item.variant.id.to_s,
          sku: item.variant.sku,
          name: item.name,
          price: item.price,
          quantity: item.quantity,
          image_url: product_image(item),
          delivery_method: 'ship_to_home',
          shipping_method: get_shipping_method_from_order(order, item),
          fulfillment_status: 'unfulfilled',
          weight: {
            value: item.variant.weight,
            weight_unit: 'pound'
          },
          origin_location: {
            id: stock_location.id,
            name: stock_location.name,
            address1: stock_location.address1,
            address2: stock_location.address2,
            city: stock_location.city,
            province: stock_location.state.name,
            country_code: stock_location.country.iso,
            zip: stock_location.zipcode
          }
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

      def shipment_line_items_hash(shipment)
        shipment.line_items.map do |item|
          shipment_line_item_hash(shipment, item)
        end
      end

      def shipment_line_item_hash(shipment, item)
        {
          shipping_method: get_shipping_method_from_shipment(shipment),
          source_product_id: item.variant.id.to_s,
          source_id: item.id.to_s,
          sku: item.variant.sku,
          name: item.name,
          price: item.price,
          quantity: item.quantity,
          image_url: product_image(item),
          fulfillment_status: 'fulfilled',
          weight: {
            value: item.variant.weight,
            weight_unit: 'pound'
          }
        }
      end

      # Get shipping method from first shipment
      def get_shipping_method_from_order(order, item)
        if order.shipments.count > 0
          get_shipping_method_from_shipment(order.shipments[0])
        else
          ''
        end
      end

      def get_shipping_method_from_shipment(shipment)
        selected_rate = shipment.shipping_rates.select { |rate| rate.selected }
        if selected_rate.count > 0
          selected_rate[0].shipping_method.name
        else
          ''
        end
      end

      def shipment_courier_id(shipment)
        get_courier_id_from_shipping_method(get_shipping_method_from_shipment(shipment))
      end

      def get_courier_id_from_shipping_method(name)
        if name.include?('FedEx')
          return 'FedEx'
        elsif name.include?('UPS')
          return 'UPS'
        elsif name.include?('USPS')
          return 'USPS'
        else
          return name
        end
      end

    end
  end
end
