module PageElementsHelpers
  def have_header(text, type = 'h1')
    have_css(type, text: text)
  end

  def have_table_header(text)
    have_css('th', text: text)
  end
end