Rails.application.routes.draw do
  mount Growth::Engine, at: "/growth/stats"
end
