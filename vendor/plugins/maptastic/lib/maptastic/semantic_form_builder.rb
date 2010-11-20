module Maptastic
  class SemanticFormBuilder < Formtastic::SemanticFormBuilder

    def multi_input(*args)
      options = args.extract_options!

      if (options[:as] == :map)
        map_input(args, options)
      else
        args.inject('') {|html, arg| html << input(arg, options)}
      end
    end

  private

    def map_div_id(methods)
      generate_html_id(map_div_id_prefix(methods))
    end
    
    def map_div_id_prefix(methods)
      methods.map(&:to_s).join('_') << '_map'
    end

    def map_input_id(method)
      generate_html_id("map_#{method}")
    end

    def map_js(methods, zoom)
      @template.content_tag("script", :type => "text/javascript") do
        "
new MaptasticMap({
    mapId: '#{map_div_id(methods)}',
    latInput: '#{map_input_id(methods.first)}',
    lngInput: '#{map_input_id(methods.last)}',
    zoom : '#{zoom}'
  });
"
      end
    end
    
    def map_input(methods, options = {})
      options[:hint] ||= "Click to select a location, then drag the marker to position"
      inputs_html = methods.inject('') {|html, method| html << input(method, :id => map_input_id(method), :as => :hidden)}
      hint_html = inline_hints_for(methods.first, options)
      label_html = label(options[:label], :label => options[:label], :input_name => map_div_id_prefix(methods) + '_input') if options[:label]
      map_container = @template.content_tag(:div, nil, :class => 'map', :id => map_div_id(methods))
      map_html = @template.content_tag(:li,  Formtastic::Util.html_safe("#{label_html}#{map_container} #{hint_html.to_s} #{options[:skip_js] == true ? '' : map_js(methods, options[:zoom]).to_s}"))

      Formtastic::Util.html_safe(inputs_html + map_html)
    end

  end

end