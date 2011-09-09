
config_file = YAML.load_file("#{::Rails.root}/config/auth_table.yml")

config = YAML.load_file("config/auth_table.yml")

USERS = Hash.new
config.each do |record|
  USERS[record[1]['user_id']] = record[1]['email']
end

