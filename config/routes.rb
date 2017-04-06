Rails.application.routes.draw do
  get 'report/prepare'
  post 'report/purchases'
  get 'report/purchases_by_month'
  post 'report/purchases_by_person'
  post 'report/purchases_values_by_person_in_months'
  get 'report/purchases_values_for_persons_in_months'  
  post 'report/purchases_person_by_person'
  get 'report/purchases_graphics'

  get 'purchases/simulate'
  post 'purchases/simulate_with_value'

  root 'purchases#index'


  devise_for :users
  resources :people
  resources :settings
  resources :credit_cards
  
  resources :installments, only: :index do
    collection do
      get :bills
      get :details_bills
      get :details_bill_per_person
    end
  end
  
  resources :purchases do
    collection do       
      get :autocomplete_person_name
      get :autocomplete_purchase_place_name
      
    end

    member do
      get :details
    end
    
  end


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
