module Firefly
  module DaylightFactor
    def self.run_simulation(grid, options)
      Directory.clear_working_dir
      working_dir = Directory.working_dir

      materials_file, faces_file, instances_file = SkpToRad.write_all_to_rad(working_dir)
      sky_file = File.join(working_dir, 'sky.rad')
      RadSky.generate_daylight_factor_sky sky_file

      points_file = File.join(working_dir, 'grid.inp')
      Grid.grid_points_to_file(grid, points_file)
      grid_file = File.join(working_dir, 'grid.attr')
      Grid.grid_attributes_to_file(grid, grid_file)

      rtrace_params = Options.rtrace_params 'Fast' # options['params_label']
      command_file = File.join(working_dir, 'command_file.bat')

      time = Time.now.to_s.gsub(':', '-')[0..18]
      result_name = "#{grid.name} #{time} daylight factor.df"
      result_file = File.join(Directory.results_dir, result_name)

      File.open(command_file, 'w') do |file|
        file.puts "cd /D \"#{working_dir}\""
        file.puts "oconv \"#{materials_file}\" \"#{faces_file}\" \"#{instances_file}\" \"#{sky_file}\"> scene.oct"
        file.puts "rtrace -I -h #{rtrace_params} scene.oct < \"#{points_file}\" ^"
        file.puts '| rcalc -e "$1=0.265*$1 + 0.670*$2 + 0.065*$3" > results.txt'
        file.puts CommandUtil.replace_command(grid_file, 'results.txt', result_file, '#RESULTS')
      end

      # Await result
      # GridResultHander.await_result result_file

      # Run command
      CommandUtil.run command_file
    end
  end
end
