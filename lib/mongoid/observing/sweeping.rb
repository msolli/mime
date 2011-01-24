module Mongoid::Observing
  module Sweeping
    extend ActiveSupport::Concern

    module ClassMethods #:nodoc:
     def cache_sweeper(*sweepers)
       configuration = sweepers.extract_options!

       sweepers.each do |sweeper|
         sweeper_instance = (sweeper.is_a?(Symbol) ? Object.const_get(sweeper.to_s.classify) : sweeper).instance

         if sweeper_instance.is_a?(Sweeper)
           around_filter(sweeper_instance, :only => configuration[:only])
         else
           after_filter(sweeper_instance, :only => configuration[:only])
         end
       end
     end
    end
  end
end
