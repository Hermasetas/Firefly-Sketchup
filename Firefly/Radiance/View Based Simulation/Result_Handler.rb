module Firefly
  module ResultHandler
    def self.await_image(file_name)
      start_time = Time.now
      timer_id = UI.start_timer(1, true) do
        # TODO: Stop timer if calculation is stopped, use a check file

        if File.exist?(file_name) && File.mtime(file_name) > start_time
          UI.stop_timer timer_id

          note = UI::Notification.new(Firefly.extension, 'Image done!')
          note.on_accept('Show Image Dialog') { Dialog::ImageResult.show_dialog }
          note.on_dismiss('Dismiss') {}
          note.show
        end
      end
    end

    def self.pcond_image(file_name)
      Directory.clear_working_dir
      working_dir = Directory.working_dir

      result_file = File.join(Directory.results_dir, file_name)
      command_file = File.join(working_dir, 'command.bat')

      File.open(command_file, 'w') do |file|
        file.puts "cd /D \"#{working_dir}\""
        file.puts "pfilt \"#{result_file}\" > pfilt_image.hdr"
        file.puts 'pcond -h pfilt_image.hdr pcond_image.hdr'
        file.puts 'ra_bmp pcond_image.hdr image.bmp'
        file.puts 'image.bmp'
      end

      SilentCommand.run_silently command_file

      # TODO: Await file and show loading animation

      File.join(working_dir, 'image.bmp')
    end

    def self.false_color_image(file_name, scale, palette)
      Directory.clear_working_dir
      working_dir = Directory.working_dir

      result_file = File.join(Directory.results_dir, file_name)
      command_file = File.join(working_dir, 'command.bat')

      label = file_name.include?('illuminance') ? 'Lux' : 'cd/m2'

      File.open(command_file, 'w') do |file|
        file.puts "cd /D \"#{working_dir}\""
        file.puts "falsecolor -i \"#{result_file}\" -s #{scale} -pal #{palette} -l #{label}> falsecolor_image.hdr"
        file.puts 'ra_bmp falsecolor_image.hdr image.bmp'
        file.puts 'image.bmp'
      end

      SilentCommand.run_silently command_file

      # TODO: Await file and show loading animation

      File.join(working_dir, 'image.bmp')
    end

    def self.raw_image(file_name)
      Directory.clear_working_dir
      working_dir = Directory.working_dir

      result_file = File.join(Directory.results_dir, file_name)
      command_file = File.join(working_dir, 'command.bat')

      File.open(command_file, 'w') do |file|
        file.puts "cd /D \"#{working_dir}\""
        file.puts "pfilt \"#{result_file}\" > pfilt_image.hdr"
        file.puts 'ra_bmp pfilt_image.hdr image.bmp'
        file.puts 'image.bmp'
      end

      SilentCommand.run_silently command_file

      # TODO: Await file and show loading animation

      File.join(working_dir, 'image.bmp')
    end
  end
end
