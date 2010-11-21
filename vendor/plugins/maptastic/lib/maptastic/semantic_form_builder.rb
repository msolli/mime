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
 MaptasticMap.init({
    mapId: '#{map_div_id(methods)}',
    latInput: '#{map_input_id(methods.first)}',
    lngInput: '#{map_input_id(methods.last)}',
    zoomInput: '#{zoom ? map_input_id(zoom) : "null"}'
  });
"
      end
    end
    
    def map_search(options)
      @template.content_tag('div') do
        text = label_tag('maptastic-search', options.delete(:search_label) || 'Search:')
        text << text_field_tag('maptastic-search')
        text
      end
    end
    
    def map_input(methods, options = {})
      options[:hint] ||= "Click to select a location, then drag the marker to position"
      inputs_html = methods.inject('') {|html, method| html << input(method, :id => map_input_id(method), :as => :hidden)}
      inputs_html << input(options[:zoom], :id => map_input_id(options[:zoom]), :as => :hidden) if options[:zoom]
      hint_html = inline_hints_for(methods.first, options)
      label_html = label(options[:label], :label => options[:label], :input_name => map_div_id_prefix(methods) + '_input') if options[:label]
      map_container = @template.content_tag(:div, nil, :class => 'map', :id => map_div_id(methods))
      map_html = @template.content_tag(:li) do
        text = [label_html]
        text << map_container
        text << map_search(options) if options.delete(:search)
        text << hint_html
        text << (options[:skip_js] ? '' : map_js(methods, options[:zoom]).to_s)
        
        Formtastic::Util.html_safe(text.join)
      end

      Formtastic::Util.html_safe(inputs_html + map_html)
    end

  end

end