require 'json'

module Firefly
  module Options
    def self.read_options_file
      return @options if @options

      path = File.join(__dir__, 'Options.json')
      s = File.read(path)
      @options = JSON.parse s
    end

    def self.rpict_params(id)
      json = read_options_file
      json['rad_params'][id]['rpict']
    end

    def self.pfilt_params(id)
      json = read_options_file
      json['rad_params'][id]['pfilt']
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
