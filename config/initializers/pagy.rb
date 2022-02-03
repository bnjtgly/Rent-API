# set global defaults and extra variables typically in the pagy.rb initializer
# they will get merged with every new Pagy instance
require 'pagy/extras/headers'
require 'pagy/extras/metadata'

Pagy::DEFAULT[:max_per_page] = 100
Pagy::DEFAULT[:items] = 20