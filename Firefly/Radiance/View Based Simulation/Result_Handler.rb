module Firefly
  module ResultHandler
    def self.await_image(file_name)
      start_time = Time.now
      timer_id = UI.start_timer(1, true) do
        if File.exist?(file_name) && File.mtime(file_name) > start_time
          UI.stop_timer timer_id
          UI.messagebox('Image done!')

          system("explorer /select,\"#{file_name.gsub('/', '\\')}\"")
        end
      end
    end
  end
end
