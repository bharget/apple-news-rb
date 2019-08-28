module AppleNewsClient
  module Component
    module ScalableImage
      extend ActiveSupport::Concern

      included do
        required_property :url
        optional_properties :accessibility_caption, :caption, :explicit_content

        property_inflection :url, 'URL'
      end
    end
  end
end
