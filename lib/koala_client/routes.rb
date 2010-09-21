# Structure copied from Clearance
module KoalaClient
  class Routes

    # In your application's config/routes.rb, draw Clearance's routes:
    #
    # @example
    #   map.resources :posts
    #   Clearance::Routes.draw(map)
    #
    # If you need to override a Clearance route, invoke your app route
    # earlier in the file so Rails' router short-circuits when it finds
    # your route:
    #
    # @example
    #   map.resources :users, :only => [:new, :create]
    #   Clearance::Routes.draw(map)
    def self.draw(map)

      map.resources :external_authentication, 
                    :collection => { :failed => :get, :logout => :get },
                    :controller => 'koala_client/external_authentication'
      
      # map.resource  :session,
      #   :controller => 'clearance/sessions',
      #   :only       => [:new, :create, :destroy]
      # 
      # end
    end
  end
end
