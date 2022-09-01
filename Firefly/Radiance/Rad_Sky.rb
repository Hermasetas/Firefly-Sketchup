module Firefly
  module RadSky
    # Creates a string representing a gensky radiance command
    # @param Time (hour, minute, day, month, year) Time and date of the sky
    # @param Location (Lat, long) Geographic location of the sky
    # @param Timezone A value between -12 and +14 representing the offset from UTC
    # @param Type One of (s,i,c) representing the type of sky
    # @return A string representation of a gensky radiance command
    def self.generate_sky_file(file_name, sky_options)
      hour, minute, day, month, year, lat, long, timezone, type =
        sky_options.values_at('hour', 'minute', 'day', 'month', 'year', 'lat', 'long', 'timezone', 'type')

      meridian = -15 * timezone.to_f

      sky_string = <<~SKY
        !gensky #{month} #{day} #{hour}:#{minute} -y #{year} -a #{lat} -o #{long} -m #{meridian} #{type}

        skyfunc glow skyglow
        0
        0
        4 1 1 1 0

        skyglow source sky
        0
        0
        4 0 0 1 180
      SKY

      File.write(file_name, sky_string, 0)
    end
  end
end