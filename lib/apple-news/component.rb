require "apple-news/components/base"
require "apple-news/components/text"
require "apple-news/components/audio"
require "apple-news/components/image"
require "apple-news/components/scalable_image"
require "apple-news/components/container"
Dir["#{File.dirname(__FILE__)}/components/*.rb"].each { |path| require path }

module AppleNewsClient
  module Component
    extend self

    def factory(data)
      return if data.nil?

      components.each do |component|
        if component.role == data[:role]
          return component.new(data)
        end
      end

      nil
    end

    private

    def components
      @components ||= self.constants.
        map { |const| self.const_get(const) }.
        select { |const| const.name.demodulize != "Base" && const.is_a?(Class) }
    end
  end
end
