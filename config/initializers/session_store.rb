# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_web-app-interfaces_session',
  :secret      => '87866953e9298fc382aa7b7c69c796ab62f34a8bb26d22b1ed053b9c784d10dc93e74b7f3a853e1b40b2c531948f4187045962a920b1e5449f0ec896cc296ee7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
