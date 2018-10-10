module NavigationHelpers
  def visit_stats_page
    visit '/growth/stats'
  end

  def visit_stats_show_page(resource:)
    visit '/growth/stats/' + resource
  end
end