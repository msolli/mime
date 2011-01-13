module Mime
  module Helpers
    module AssociationsHelper
      def remove_empty_associations_for(*associations)
        associations.each do |method|
          self.send(method).each do |item|
            if item.fields.keys.all?{|key| item.attributes[key].blank?}
              self.remove(item)
            end
          end
        end
      end
    end
  end
end