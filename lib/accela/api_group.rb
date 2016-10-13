module Accela
  class APIGroup
    attr_reader :model, :config

    def self.as_class_method(*args)
      eclass = (class << self; self; end)
      args.map(&:to_sym).each do |method|
        eclass.send(:define_method, method) do |*args|
          new(nil).public_send(method, *args)
        end
      end
    end

    def initialize(*args)
      @config = args.detect { |arg| arg.is_a?(Configuration) } || Configuration
      @model = args.detect { |arg| arg.is_a?(Model) }
    end

    private

    def fetch_has_many(api_class, translator_class, model_class, *args)
      fetch_many(api_class, translator_class, model_class, model.id, *args)
    end

    def fetch_many(api_class, translator_class, model_class, *args)
      payload_hashes = api_class.new(config).result(*args)
      input_hashes = translator_class.json_to_ruby(payload_hashes)
      input_hashes.map {|input_hash| model_class.create(input_hash) }
    end

    def fetch_one(api_class, translator_class, model_class, *args)
      payload_hash = api_class.new(config).result(*args)
      input_hashes = translator_class.json_to_ruby([payload_hash])
      input_hashes.map {|input_hash| model_class.create(input_hash) }.first
    end
  end
end
