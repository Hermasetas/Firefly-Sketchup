module Firefly
  module DaylightFactor
    def self.run_simulation(grid, options)
      Directory.clear_working_dir
      working_dir = Directory.working_dir

      materials_file, faces_file, instances_file = SkpToRad.write_all_to_rad(dir_name)
      sky_file = File.join(working_dir, 'sky.rad')
      RadSky.generate_daylight_factor_sky sky_file

      grid_file = File.join(working_dir, 'grid.inp')
      Grid.grid_to_file(grid, grid_file)

      rtrace_params = Options.rtace_params options['params_label']
      command_file = File.join(working_dir, 'command_file.bat')

      t = Time.now.to_s.gsub(':', '-')[0..18]
      result_name = "#{t} daylight factor.df"
      result_file = File.join(Directory.results_dir, result_name)

      File.open(command_file, 'w') do |file|
        file.puts "cd /D \"#{working_dir}\""
        file.puts "oconv \"#{materials_file}\" \"#{faces_file}\" \"#{instances_file}\" #{sky_file}> scene.oct"
        file.puts "rtrace -I #{rtrace_params} scene.oct < #{grid_file} ^"
        file.puts "| rcalc -e \"$1=0.265*$1 + 0.670*$2 + 0.065*$3\" > #{result_file}"
      end

      # Await result
      # GridResultHander.await_result result_file

      # Run command
      UI.openURL("file://#{command_file}")
    end
  end
end
