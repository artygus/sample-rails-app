Rails.application.routes.draw do
  resources :trips do
    collection do
      post :search
    end
  end


  constraints Clearance::Constraints::SignedIn.new { |user| user.admin? } do
    namespace :admin do
      resources :users
    end
  end

  constraints Clearance::Constraints::SignedIn.new do
    root to: redirect('/trips', status: 302), as: :signed_in_root
  end

  constraints Clearance::Constraints::SignedOut.new do
    root to: 'clearance/sessions#new'
  end

end
