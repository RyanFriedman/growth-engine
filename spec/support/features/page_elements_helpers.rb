module PageElementsHelpers
  def have_header(text, type = 'h1')
    have_css(type, text: text)
  end
end