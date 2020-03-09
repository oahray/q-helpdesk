# Be sure to restart your server when you modify this file.

# Specify a serializer for the signed and encrypted cookie jars.
# Valid options are :json, :marshal, and :hybrid.
Rails.application.config.session_store :cookie_store, key: "_q_helpdesk_session", expire_after: 2.days
