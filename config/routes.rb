ResizorSampleApp::Application.routes.draw do
  resources :items
  
  root :to => 'items#index'
end
