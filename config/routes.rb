get 'email_logs', :to => 'email_logs#index'
get 'email_logs/:object_type/:object_id', :to => 'email_logs#show', :as => :object_email_logs

get 'email_tracker/:image.:format', :to => 'email_tracker#index', :image => '1x1', :format => 'png', :as => :email_tracker
