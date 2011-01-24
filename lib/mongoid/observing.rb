module Mongoid
  module Observing    
    CALLBACKS = [
      :before_create, :before_destroy, :before_save, :before_update,
      :before_validation, :after_create, :after_destroy, :after_save,
      :after_update, :after_validation
    ]

    def self.included(base)
      base.module_eval { include ActiveModel::Observing }

      CALLBACKS.each do |callback|
        callback_method = :"notify_observers_#{callback}"

        base.module_eval <<-RUBY, __FILE__, __LINE__+1
          #{callback}(#{callback_method.inspect})

          def #{callback_method}(&block)
            notify_observers(#{callback.inspect}, &block)
          end
          private #{callback_method.inspect}
        RUBY
      end
    end
  end
end
