module AppleNewsClient
  module Request
    class Post
      attr_reader :url
      attr_accessor :fields

      def initialize(url, config = AppleNewsClient.config)
        @config = config
        @url = URI::parse(File.join(@config.api_base, url))
        @fields = {}
      end

      def call
        http = Net::HTTP.new(@url.hostname, @url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        # The API can be really slow, sometimes.
        http.read_timeout = 120


        res = http.post(@url, content_body, headers)
        JSON.parse(res.body)
      end

      private

      def multipart
        @multipart ||= Net::HTTP::Post::Multipart.new(@url.path, @fields, {
          parts: {
            'metadata' => {
              'Content-Type' => 'application/json'
            }
          }
        })
      end

      def content_body
        body = multipart.body_stream.read.gsub("\"article.json\"", "article.json")
        multipart.body_stream.rewind
        body
      end

      def authorization
        security = AppleNewsClient::Security.new('POST', @url, @config)
        security.content_type = "multipart/form-data; boundary=#{multipart.boundary}"
        security.content_body = content_body

        security.authorization
      end

      def headers
        {
          'Authorization' => authorization,
          'Content-Type' => "multipart/form-data; boundary=#{multipart.boundary}"
        }
      end
    end
  end
end
