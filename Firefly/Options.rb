require 'json'

module Firefly
  module Options
    def self.read_options_file
      path = File.join(__dir__, 'Options.json')
      s = File.read(path)
      JSON.parse s
    end

    def self.rad_params(index)
      # TODO: Super sampling on higher levels eg pfilt -x /2 -y /2
      json = read_options_file
      json['rad_params'][index]
    end

    def self.all_cities
      json = read_options_file
      json['cities']
    end

    def self.city(city_name)
      json = read_options_file
      json['cities'][city_name]
    end
  end
end
