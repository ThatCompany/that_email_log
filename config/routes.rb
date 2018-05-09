get 'email_logs', :to => 'email_logs#index'
get 'email_logs/:object_type/:object_id', :to => 'email_logs#show'
