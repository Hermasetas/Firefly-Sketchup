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

    def self.run(command_file)
      UI.openURL("file://#{command_file}")
    end

    # Creates a command to replace a specified keyword in a file with the contents of another file
    # @param base_file The file to insert text into
    # @param content_file The file which contents to insert into the base_file
    # @param result_file The path where the result should be saved
    # @param keyword The keyword in base_file to replace with the contents of content_file
    # @return A string representing a powershell command
    def self.replace_command(base_file, content_file, result_file, keyword)
      <<~COMMAND
        powershell -Command "(gc -encoding Utf8 '#{base_file}') -replace '#{keyword}', (gc -encoding Utf8 -raw '#{content_file}') | Out-File -encoding Utf8 '#{result_file}'"
      COMMAND
    end
  end
end
