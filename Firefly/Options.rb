require 'json'

module Firefly
  module Options
    def self.read_options_file
      path = 'Options.json'
      s = File.read(path)
      JSON.parse s
    end

    def self.get_rad_params(index)
      # TODO: Super sampling on higher levels eg pfilt -x /2 -y /2
      json = readOptionsFile
      json['rad_params'][index]
    end

    def self.get_city(city_name)
      json = readOptionsFile
      json['cities'][city_name]
    end
  end
end
