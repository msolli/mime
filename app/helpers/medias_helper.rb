module MediasHelper
  
  def df_image_tag(url, options = {})
    if Rails.env.development?
      image_tag("http://ableksikon.no#{url}", options)
    else
      image_tag("#{request.scheme}://#{request.host_with_port}#{url}", options)
    end
  end
end
