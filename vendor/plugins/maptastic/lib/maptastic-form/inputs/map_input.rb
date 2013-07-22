module Formtastic
  module Inputs
    class MapInput
      include Formtastic::Inputs::Base

      def to_html
        set_default_fields
        input_wrapping do
          hidden_fields_html <<
          label_html <<
          map_tag <<
          map_js
        end
      end

      def set_default_fields
        options[:input_html]||={}
        MAP_OPTIONS.each{|opt| options[:input_html][opt]||=opt}
      end

      def hidden_field_html key
        template.hidden_field_tag("#{object_name}[#{input_html_options[key]}]", value(key))  
      end

      def hidden_fields_html
        MAP_OPTIONS.map{|opt| hidden_field_html opt}.join.html_safe
      end
      
      def value key
        object.send(key) if object && object.respond_to?(key)
      end

      def additional_id key
        [
          builder.custom_namespace,
          sanitized_object_name,
          dom_index,
          input_html_options[key]
        ].reject { |x| x.blank? }.join('_').to_sym
      end

      def map_tag
        template.content_tag(:div, nil, :class => 'map', :id => input_html_options[:id])
      end

      def map_js
        template.content_tag("script", :lang => "javascript") do
        "jQuery().ready(function() {
          jQuery('##{input_html_options[:id]}').MaptasticMap({
              latitude:'#{additional_id :latitude}',
              longitude:'#{additional_id :longitude}',
              zoom:'#{additional_id :zoom}'});
        });"
        end
      end
    end
  end
end