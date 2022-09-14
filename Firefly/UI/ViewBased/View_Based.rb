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

        dialog.add_action_callback('run_perspective_rendering') do |_context, options|
          if options['params_label'] == 'Max' &&
             UI.messagebox('Warning, max render can be very slow!', MB_OKCANCEL) == IDCANCEL
            next
          end

          PerspectiveRendering.run_rendering options
        end

        dialog.add_action_callback('get_city') do |_context, city|
          values = Options.city city
          values = values.to_s.gsub('=>', ':')
          dialog.execute_script "updateCity(#{values})"
        end

        dialog.add_action_callback('get_city_list') do |_context|
          cities = Options.all_cities.keys.sort
          dialog.execute_script "updateCitySelect(#{cities})"
        end

        dialog.show
      end
    end
  end
end
