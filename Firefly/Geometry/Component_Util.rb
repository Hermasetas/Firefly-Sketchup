module Firefly
  # A module with handy component methods
  module ComponentUtil
    puts 'ComponentUtil loaded'

    def self.calc_all_definition_levels(definitions)
      levels = Hash.new(0)

      definitions.each do |defi|
        next if defi.count_instances.zero?

        current_level = 0

        calc_definition_levels(defi, levels, current_level)
      end
      levels
    end

    def self.calc_definition_levels(defi, levels, current_level)
      levels[defi] = [levels[defi], current_level].max

      defi.entities.each do |e|
        case e
        when Sketchup::Group
          calc_definition_levels(e, levels, current_level + 1)
        when Sketchup::ComponentInstance
          calc_definition_levels(e.definition, levels, current_level + 1)
        end
      end
    end
  end
end
