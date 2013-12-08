HqServer::Application.routes.draw do
  resources :home
  resources :admins
  post 'admin/item_dump', to: 'admins#item_dump'
  resources :sessions
  resources :items, :path => 'products'
  post 'products/sync/:id', to: 'items#sync'
  get 'products/stats', to: 'items#stats'
  resources :shops, :path => 'stores'
  resources :shop_items, :path => 'store/products'
  post 'shop_items/batch_add', to: 'shop_items#batch_add'
  #resources :sales
  get 'sales', to: 'sales#index'
  get 'sales/all', to: 'sales#all'
  get 'sales/stats/:id', to: 'sales#stats', as: 'sales_stats'
  post 'sales/transaction_dump', to: 'sales#transaction_dump'
  post 'sales/:id', to: 'sales#create'
  resources :deliveries
  get 'deliveries/api', to: 'deliveries#api', as: 'delivery_api'
  post 'deliveries/:id/approve', to: 'deliveries#approve', as: 'delivery_approve'
  post 'deliveries/:id/dispatch', to: 'deliveries#mark_dispatched', as: 'delivery_dispatch'
  root 'sessions#new'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
