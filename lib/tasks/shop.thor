# You may/may not need this next line depending on your Rails/thor setup
require File.expand_path('config/environment.rb')

require 'datashift'
require 'datashift_spree'

DataShift::load_commands
DataShift::SpreeEcom::load_commands