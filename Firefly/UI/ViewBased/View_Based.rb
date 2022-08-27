module Firefly
  module Dialog
    module ViewBased
      def self.create_dialog
        hmtl_file = File.join(__dir__, 'ViewBased.html')

        dialog = UI::HtmlDialog.new(
          dialog_title: 'View based rendering',
          width: 300,
          height: 600,
          resizable: false,
          style: UI::HtmlDialog::STYLE_DIALOG
        )
        dialog.set_file hmtl_file
        dialog
      end

      def self.show_dialog
        dialog = create_dialog

        dialog.add_action_callback('run_perspective_rendering') do |context, param_index|
          rad_params = Options.get_rad_params(param_index.to_i)
          dir_name = 'C:\Users\herma\Desktop\New folder'
          PerspectiveRendering.run_simple_rendering dir_name, rad_params 
        end

        dialog.show
      end
    end
  end
end
