module Firefly
  module Dialog
    module CreateGrid
      class << self
        def show_dialog
          dialog = create_dialog

          dialog.add_action_callback('create_grid') do |context, face_id, spacing, height|
            face = Sketchup.active_model.find_entity_by_id face_id.to_i
            grid = Grid.create_grid face, spacing.to_f, height.to_f
            Grid.create_cpoints grid
          end

          dialog.show
        end
        
        private
        
        def create_dialog
          hmtl_file = File.join(__dir__, 'CreateGrid.html')
          
          dialog = UI::HtmlDialog.new(
            dialog_title: 'Create Grid',
            width: 300,
            height: 600,
            resizable: false,
            style: UI::HtmlDialog::STYLE_DIALOG
          )
          dialog.set_file hmtl_file

          setup_selection_listener(dialog)

          dialog
        end

        def setup_selection_listener(dialog)
          unless @selListener
            @selListener = SelectorListener.new
            Sketchup.active_model.selection.add_observer @selListener
          end

          @selListener.set_dialog dialog
        end

        class SelectorListener < Sketchup::SelectionObserver
          def set_dialog(dialog)
            @dialog = dialog
          end

          def onSelectionAdded(selection, entity)
            updateSelection
          end
          
          def onSelectionBulkChange(selecetion)
            updateSelection
          end
          
          def onSelectionCleared(selection)
            updateSelection
          end
          
          def onSelectionRemoved(selection, entity)
            updateSelection
          end

          def updateSelection
            selection = Sketchup.active_model.selection
            
            if selection.count == 1 && selection.first.is_a?(Sketchup::Face)
              face_id = selection.first.entityID
            else
              face_id = ''
            end

            @dialog.execute_script("updateFaceLabel('#{face_id}')")
          end
        end
      end
    end
  end
end
