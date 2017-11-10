Rails.application.routes.draw do
  mount Decidim::Core::Engine => '/'
end