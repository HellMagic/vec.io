# Be sure to restart your server when you modify this file.

require 'action_dispatch/middleware/session/dalli_store'
VecIo::Application.config.session_store :dalli_store, memcache_server: Preference.memcache.servers, key: Preference.session_key
