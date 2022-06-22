module Spree
  class Image < Asset
    module Configuration
      module ActiveStorage
        extend ActiveSupport::Concern

        included do
          validate :check_attachment_presence
          validate :check_attachment_content_type

          has_one_attached :attachment

          default_scope { includes(attachment_attachment: :blob) }

          def self.styles
            @styles ||= {
              mini: '48x48>',
              small: '180x180>',
              product: '240x240>',
              pdp_thumbnail: '180x180>',
              plp_and_carousel: '448x600>',
              plp_and_carousel_xs: '180x180>',
              plp_and_carousel_sm: '180x180>',
              plp_and_carousel_md: '180x180>',
              plp_and_carousel_lg: '240x240>',
              large: '1000x1000>',
              plp: '240x240>',
              zoomed: '1000x1000>'
            }
          end

          def default_style
            :product
          end

          def accepted_image_types
            %w(image/jpeg image/jpg image/png image/gif)
          end

          def check_attachment_presence
            unless attachment.attached?
              errors.add(:attachment, :attachment_must_be_present)
            end
          end

          def check_attachment_content_type
            if attachment.attached? && !attachment.content_type.in?(accepted_image_types)
              errors.add(:attachment, :not_allowed_content_type)
            end
          end
        end
      end
    end
  end
end
