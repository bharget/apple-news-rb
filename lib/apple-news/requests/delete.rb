module AppleNewsClient
  module Request
    class Delete
      attr_reader :url

      def initialize(url, config = AppleNewsClient.config)
        @config = config
        @url = URI::parse(File.join(@config.api_base, url))
      end

      def call(params = {})
        http = Net::HTTP.new(@url.hostname, @url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        res = http.delete(@url, headers)
        res.code == '204' ? true : JSON.parse(res.body)
      end

      private

      def headers
        security = AppleNewsClient::Security.new('DELETE', @url.to_s, @config)
        { 'Authorization' => security.authorization }
      end
    end
  end
end
