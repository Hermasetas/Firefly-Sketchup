module Firefly
  module CommandUtil
    def self.run_silently(command_file)
      dir = File.dirname command_file
      silent_file = File.join(dir, 'silent.vbs')

      File.open(silent_file, 'w') do |file|
        file.puts 'Set WshShell = CreateObject("WScript.Shell")'
        file.puts "WshShell.Run chr(34) & \"#{command_file}\" & Chr(34), 0"
        file.puts 'Set WshShell = Nothing'
      end

      # UI.openURL("file://#{silent_file}")
      UI.openURL("file://#{command_file}")
    end
  end
end
