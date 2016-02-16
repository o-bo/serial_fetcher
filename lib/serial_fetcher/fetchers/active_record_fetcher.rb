module SerialFetcher
  module Fetchers
    class ActiveRecordFetcher

      def self.get
        ->(param_name, param) {
          begin
            klass_name = param_name.camelize
            klass = klass_name.constantize
            klass.send(:find, param)
          rescue NameError
            nil
          end
        }
      end
    end
  end
end
