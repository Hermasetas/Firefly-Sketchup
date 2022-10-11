module Firefly
  module Dialog
    module GridBased
      class << self
        def show_dialog
          dialog = create_dialog
          dialog.show
        end

        private

        def create_dialog
          hmtl_file = File.join(__dir__, 'GridBased.html')

          dialog = UI::HtmlDialog.new(
            dialog_title: 'Grid Based Simulation',
            width: 300,
            height: 600,
            resizable: false,
            style: UI::HtmlDialog::STYLE_DIALOG
          )
          dialog.set_file hmtl_file

          dialog
        end
      end
    end
  end
end
