module Rossum
  class Downloader
    def self.call(id, token)
      new(id, token).call
    end

    def initialize(id, token)
      @id = id
      @token = token
    end

    def call
      http = Net::HTTP.new("all.rir.rossum.ai", 443)
      http.use_ssl = true
      uri = URI("https://all.rir.rossum.ai/document/#{@id}")
      req = Net::HTTP::Get.new(uri)
      req['Authorization'] = "secret_key #{@token}"

      response = http.start do |con|
        con.request(req)
      end

      JSON.parse(response.body)
    end
  end
end
