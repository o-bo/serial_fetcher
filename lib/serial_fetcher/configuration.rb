require "serial_fetcher/fetchers/active_record_fetcher"

module SerialFetcher
  class Configuration

    attr_accessor :fetcher


    def initialize
      @fetcher = SerialFetcher::Fetchers::ActiveRecordFetcher.get
    end
  end
end
