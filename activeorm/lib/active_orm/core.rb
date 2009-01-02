module ActiveOrm
  class ActiveOrmError < StandardError; end
  class ProxyNotFoundException < ActiveOrmError; end
  class AbstractProxyMethod < ActiveOrmError; end

  module Core
    module ClassMethods
      def proxyable? obj
        !find_key(obj).empty?
      end

      def new obj
        @_proxy_cache ||= {}
        registry = @_proxy_registry[find_key(obj)]
        registry ? registry.new(obj) : (raise ProxyNotFoundException)
      end

      def register obj_class, obj_proxy_class
        @_proxy_registry ||= {}
        @_proxy_registry[obj_class.to_s] = obj_proxy_class
      end
      
      protected
        def find_key(obj)
          @_proxy_key_cache ||= {}
          @_proxy_key_cache[obj.class.to_s] ||= obj.class.ancestors.find{|a| @_proxy_registry[a.to_s] }.to_s || obj.class.included_modules.find{|a| @_proxy_registry[a].to_s }.to_s
        end
    end
  end
end