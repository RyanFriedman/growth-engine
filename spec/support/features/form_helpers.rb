module FormHelpers
  def visit_stats_page
    visit '/growth/stats'
  end

  def submit_select_form(form, option)
    within(form) do
      select option

      click_button 'Submit'
    end
  end
end