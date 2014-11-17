module ParksHelper
  
  def park_image_width
    300
  end
  
  def park_image_height
    park_image_width * (3 / 4)
  end

  def park_image_fit
    'clip'
  end

end