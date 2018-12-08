require 'json'

module Rossum
  class Sender
    BOUNDARY = '0123456789ABLEWASIEREISAWELBA9876543210'.freeze

    def self.call(raw_content, filename, content_type, token)
      new(raw_content, filename, content_type, token).call
    end

    def initialize(raw_content, filename, content_type, token)
      @raw_content = raw_content
      @filename = filename
      @content_type = content_type
      @token = token
    end

    def call
      headers = { 'Content-Type' => "multipart/form-data; boundary=#{BOUNDARY}",
                  'Authorization' => "secret_key #{@token}"
      }

      data =
        "--#{BOUNDARY}\r\nContent-Disposition: form-data; name=\"file\"; filename=\"#{@filename}\"\r\nContent-Type: #{@mime_type}\r\n\r\n#{@raw_content}\r\n--#{BOUNDARY}--"

      http = Net::HTTP.new("all.rir.rossum.ai", 443)
      http.use_ssl = true

      response = http.start do |con|
        con.post('/document', data, headers)
      end

      JSON.parse(response.body)
    end
  end
end
