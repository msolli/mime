module Mongoid::Observing
  class Observer < ActiveModel::Observer
    protected
      def observed_classes
        klasses = super
        klasses + klasses.map { |klass| klass.descendants }.flatten
      end

      def add_observer!(klass)
        super
        define_callbacks klass
      end

      def define_callbacks(klass)
        observer = self

        Mongoid::Observing::CALLBACKS.each do |callback|
          next unless respond_to?(callback)
          klass.send(callback){|record| observer.send(callback, record)}
        end
      end
  end
end