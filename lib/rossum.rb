require 'restclient'
require 'json'

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
    def self.call(dataset, token)
      new(dataset, token).call
    end

    def initialize(dataset, token)
      @dataset = dataset
      @token = token
    end

    def call
      auth="secret_key #{token}"

      RestClient.log = 'stdout'

      response = RestClient.post "https://all.rir.rossum.ai/document",
        { file: File.new(@dataset.source_path, 'rb') },
        { Authorization: auth }

      JSON.parse(response.body)
    end
  end

  class Downloader
    def self.call(dataset, id, token)
      new(dataset, id, token).call
    end

    def initialize(dataset, id, token)
      @dataset = dataset
      @id = id
      @token = token
    end

    def call
      auth = "secret_key #{token}"

      RestClient.log = 'stdout'

      response = RestClient.get "https://all.rir.rossum.ai/document/#{@id}", { Authorization: auth }

      JSON.parse(response.body)
    end
  end
end
