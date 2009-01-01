module ActiveOrm
  module Proxies
    class SequelProxy < AbstractProxy
      def new?
        model.new?
      end

      def valid?
        model.valid?
      end
    end
  end
end