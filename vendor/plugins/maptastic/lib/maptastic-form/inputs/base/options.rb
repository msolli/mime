module Formtastic
  module Inputs
    module Base
      module Options
        MAP_OPTIONS=[:longitude, :latitude, :zoom]
        def formtastic_options_with_map
          formtastic_options_without_map + MAP_OPTIONS
        end
        alias_method_chain :formtastic_options, :map
      end
    end
  end
end