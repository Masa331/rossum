require 'json'

# Thanks Cody Brimhall for his time and willingness in the following SO:
# https://stackoverflow.com/questions/184178/ruby-how-to-post-a-file-via-http-as-multipart-form-data

module Rossum
  class Result
    def initialize(raw)
      @raw = raw
    end

    def currency_id
      return nil if @raw['status'] != 'ready'

      @raw['currency']
    end

    def invoice_id
      value_for('invoice_id')
    end

    def account_num
      value_for('account_num')
    end

    def bank_num
      value_for('bank_num')
    end

    def iban
      value_for('iban')
    end

    def bic
      value_for('bic')
    end

    def var_sym
      value_for('var_sym')
    end

    def const_sym
      value_for('const_sym')
    end

    def spec_sym
      value_for('spec_sym')
    end

    def amount_total
      value_for('amount_total')
    end

    def amount_due
      value_for('amount_due')
    end

    def date_issue
      value_for('date_issue')
    end

    def date_due
      value_for('date_due')
    end

    def date_uzp
      value_for('date_uzp')
    end

    def sender_name
      value_for('sender_name')
    end

    def sender_ic
      value_for('sender_ic')
    end

    def sender_dic
      value_for('sender_dic')
    end

    def recipient_name
      value_for('recipient_name')
    end

    def recipient_ic
      value_for('recipient_ic')
    end

    def recipient_dic
      value_for('recipient_dic')
    end

    def amount_rounding
      value_for('amount_rounding')
    end

    def invoice_type
      value_for('invoice_type')
    end

    def value_for(name)
      return nil if @raw['status'] != 'ready'

      field = @raw['fields'].find { |field| field['name'] == name }

      if field
        field['value']
      end
    end
  end

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
