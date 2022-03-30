module ApplicationHelper

  # Use for additional meta tag, i.e. <meta name="robots" content="noindex">
  def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
  end
  
end
