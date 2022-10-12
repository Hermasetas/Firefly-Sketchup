module Firefly
  module Dialog
    module GridBased
      class << self
        def show_dialog
          dialog = create_dialog

          dialog.add_action_callback('get_grid_names') do |_context|
            grid_names = get_grid_names
            dialog.execute_script("updateGridNames(#{grid_names})")
          end

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

        def get_grid_names
          ents = Sketchup.active_model.entities
          grids = ents.filter { |e| e.is_a?(Sketchup::Group) && e.get_attribute('Firefly', 'isGrid') }
          grids.map(&:name)
        end
      end
    end
  end
end
