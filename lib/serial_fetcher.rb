require "serial_fetcher/version"
require "serial_fetcher/configuration"

module SerialFetcher

  class << self
    attr_accessor :configuration
  end


  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end


  def self.fetch(params, schema={})
    config = self.configuration ||= Configuration.new
    fetcher = config.fetcher

    raise "You must provide a fetcher method." if fetcher.nil?
    raise "You must provide a hash for params." if params.nil?
    raise "You must provide the key id for the basic resource to be fetched." if schema[:id].nil?

    params.keys.each_with_object({}) do |k, res|
      key_id = schema[k]
      if key_id
        param_name = key_id.to_s
        res[key_id] = fetcher.(param_name, params[k])
      else
        if /.*_id/.match(k.to_s)
          param_name = k.to_s.split('_id').first
          res[param_name.to_sym] = fetcher.(param_name, params[k])
        end
      end
    end
  end
end
