#
# Tracks Third Party Services
#   api: which api it belongs to
#   name: name of the third party service
#   health: health of the service
#   active:
#
class ThirdParty < ApplicationRecord
  HEALTH = {
    healthy: 'healthy',   # up with no errors
    unstable: 'unstable', # it's up but returning errors sometimes
    unavailable: 'unavailable', # up temporarily unavailable (ie returning 500s)
  }
end