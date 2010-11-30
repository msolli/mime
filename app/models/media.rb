class Media
  include Mongoid::Document
  include Mongoid::Timestamps
  
  references_many :articles, :stored_as => :array, :inverse_of => :medias
  
  field :description, :type => String
  field :date, :type => DateTime
  field :author, :type => String
  field :file_uid, :type => String
  
  attachment_accessor :file
  
  validates_presence_of :file
  
  
  def crop_zoom_url(params)
    params.dup.each do |k, v|
      params[k.to_sym] = v.to_i
    end
    
    file.process(:resize, "#{params[:canvas_w]}x#{params[:canvas_h]}")
      .process(:crop,
      :width  => params[:w],
      :height => params[:h],
      :x      => params[:x],
      :y      => params[:y]
    ).url   
  end
  
end
