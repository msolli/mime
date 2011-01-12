module MediasHelper
  
  def df_image_tag(url, options = {})
    image_tag("#{request.scheme}://#{request.host_with_port}#{url}", options)
  end
  
end
