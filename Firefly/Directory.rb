module Firefly
  # A module for fetching working directories
  module Directory
    class << self
      def working_dir
        create_temp_dir 'firefly-calculations'
      end

      def clear_working_dir
        FileUtils.remove_dir working_dir
        working_dir
      end

      def results_dir
        create_temp_dir 'firefly-results'
      end

      def preview_dir
        create_temp_dir 'firefly-previews'
      end

      private

      def create_temp_dir(dir_name)
        tmpdir = Dir.tmpdir
        dir = File.join(tmpdir, dir_name)
        Dir.mkdir dir unless Dir.exist? dir
        dir
      end

      class FileRemover < Sketchup::AppObserver
        def onQuit
          FileUtils.remove_dir Directory.working_dir
          FileUtils.remove_dir Directory.results_dir
          FileUtils.remove_dir Directory.preview_dir
        end
      end

      unless file_loaded? __FILE__
        Sketchup.add_observer FileRemover.new
        file_loaded __FILE__
      end
    end
  end
end
