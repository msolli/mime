# We set the cache store here instead of in the environments because we need Mongoid to be initialized
# This is also the reason why we do the ugly hack of re-assigning RAILS_CACHE (which is what Rails.cache points to)

ActionController::Base.cache_store = :mongo_store, 'rails_cache', { 
  :db => Mongoid.database,
  :compress => true,
  :compress_threshold => 8.kilobytes,
  :expires_in => (7.days.from_now - Time.now).to_i
}
RAILS_CACHE = ActionController::Base.cache_store # Throws a warning for re-initialization, but is definitely worth it
