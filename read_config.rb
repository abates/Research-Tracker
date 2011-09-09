#!/usr/bin/ruby

require 'yaml'

config = YAML.load_file("config/auth_table.yml")

config.each do |record|
  puts record[1].inspect
  puts
end


