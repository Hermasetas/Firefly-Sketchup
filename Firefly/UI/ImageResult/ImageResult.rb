module Firefly
  module Dialog
    module ImageResult
      class << self
        def show_dialog
          dialog = create_dialog

          dialog.add_action_callback('create_image') do |_context, options|
            create_image options
          end

          dialog.add_action_callback('get_result_files') do |_context|
            result_files = fetch_result_files
            dialog.execute_script "updateFileSelect(#{result_files})"
          end

          dialog.add_action_callback('get_preview') do |_context, file|
            preview_file = "#{File.basename(file, '.hdr')}.bmp"
            preview_file = File.join(Directory.preview_dir, preview_file)
            dialog.execute_script "updatePreview('#{preview_file}')"
          end

          dialog.show
        end

        private

        def create_dialog
          hmtl_file = File.join(__dir__, 'ImageResult.html')

          dialog = UI::HtmlDialog.new(
            dialog_title: 'Image Results',
            width: 300,
            height: 600,
            resizable: false,
            style: UI::HtmlDialog::STYLE_DIALOG
          )
          dialog.set_file hmtl_file
          dialog
        end

        def fetch_result_files
          results_dir = Directory.results_dir
          files = Dir["#{results_dir}/*"]
          files.map { |f| File.basename f }
        end

        def create_image(options)
          case options['type']
          when 'Human Conditioned'
            create_pcond_image options
          when 'False Color'
            create_false_color_image options
          when 'Raw Image'
            create_raw_image options
          end
        end

        def create_pcond_image(options)
          ResultHandler.pcond_image options['file_name']
        end

        def create_false_color_image(options)
          ResultHandler.false_color_image(*options.values_at('file_name', 'falsecolor_scale', 'falsecolor_palette'))
        end

        def create_raw_image(options)
          ResultHandler.raw_image options['file_name']
        end
      end
    end
  end
end
