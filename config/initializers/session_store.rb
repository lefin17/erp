# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_PolygraphERP_session',
  :secret      => '574fda5514ebc225f896abf47f29e54555e12d1bd77e9e0a95183d663d3bd30cdd11698dbc56f2ef768f2ded1e4cbea83d90d931ce030ab5c5797a335a7bf63b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
