Rails.application.routes.draw do
  mount Growth::Engine => '/growth/stats'
end
