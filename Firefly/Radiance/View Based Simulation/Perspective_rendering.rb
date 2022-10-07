module Firefly
  # A module that executes perspective renderings in Radiance
  module PerspectiveRendering
    def self.run_rendering(options)
      Directory.clear_working_dir
      working_dir = Directory.working_dir

      materials_file, faces_file, instances_file = SkpToRad.write_all_to_rad(working_dir)
      view = View.grab_perspective_view

      if options['sky_options']
        sky_file = File.join(working_dir, 'sky.rad')
        RadSky.generate_sky_file sky_file, options['sky_options']
        sky_file = "\"#{sky_file}\""
      else
        sky_file = ''
      end

      rpict_params = Options.rpict_params options['params_label']
      render_type = options['render_type'] == 'illuminance' ? '-i' : ''
      command_file = File.join(working_dir, 'render_command.bat')

      t = Time.now.to_s.gsub(':', '-')[0..18]
      result_name = "#{t} simple-render #{options['render_type']}"
      result_file = File.join(Directory.results_dir, "#{result_name}.hdr")
      preview_file = File.join(Directory.preview_dir, "#{result_name}.bmp")

      File.open(command_file, 'w') do |file|
        file.puts "cd /D \"#{working_dir}\""
        file.puts "oconv \"#{materials_file}\" \"#{faces_file}\" \"#{instances_file}\" #{sky_file}> scene.oct"
        file.puts "rpict -t 1 #{render_type} #{rpict_params} #{view} scene.oct > result.hdr"
        file.puts "copy result.hdr \"#{result_file}\""

        file.puts 'echo "Generating preview...'
        file.puts 'pfilt -x 250 -p 1 result.hdr > preview.hdr'
        file.puts "ra_bmp preview.hdr \"#{preview_file}\""
      end

      # Setup wait for result
      ViewResultHandler.await_image result_file

      # Run command
      CommandUtil.run command_file
    end
  end
end
