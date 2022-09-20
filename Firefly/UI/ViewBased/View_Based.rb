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

          Attributes.save_sky_options options['sky_options']
          PerspectiveRendering.run_rendering options
        end

        dialog.add_action_callback('get_city') do |_context, city|
          values = Options.city city
          dialog.execute_script "updateCity(#{values.to_json})"
        end

        dialog.add_action_callback('get_city_list') do |_context|
          cities = Options.all_cities.keys.sort
          dialog.execute_script "updateCitySelect(#{cities})"
        end

        dialog.add_action_callback('get_prev_sky_options') do |_context|
          sky_options = Attributes.sky_options
          dialog.execute_script "updateSkyOptions(#{sky_options.to_json})" if sky_options
        end

        dialog.show
      end
    end
  end
end
