module Firefly
  module Dialog
    def self.init_ui
      show_viewbased_window = UI::Command.new('Show View-based dialog') { ViewBased.show_dialog }
      UI.menu('Extensions').add_item show_viewbased_window

      show_imageresult_window = UI::Command.new('Show Image Result dialog') { ImageResult.show_dialog }
      UI.menu('Extensions').add_item show_imageresult_window

      show_grid_window = UI::Command.new('Show Grid dialog') { CreateGrid.show_dialog }
      UI.menu('Extensions').add_item show_grid_window
    end
  end
end
