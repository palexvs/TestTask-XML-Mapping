require 'settingslogic'

class Settings < Settingslogic
  source "config/application.yml"
  # namespace "defaults"
  namespace "memcache"
end