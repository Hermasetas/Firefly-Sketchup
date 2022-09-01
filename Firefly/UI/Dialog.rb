module Firefly
  module Dialog
    def self.init_ui
      show_viewbased_window = UI::Command.new('Show View-based dialog') { ViewBased.show_dialog }
      show_viewbased_window.menu_text = 'Show View-based dialog'
      UI.menu('Extensions').add_item show_viewbased_window
    end
  end
end
