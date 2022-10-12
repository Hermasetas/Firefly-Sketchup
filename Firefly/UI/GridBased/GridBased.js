function initUI() {
    updateGridNames();
}

function updateGridNames(gridNames) {
    if(gridNames) {
        let select = document.getElementById('grid_select');

        for (const gn of gridNames) {
            let option = document.createElement('option');
            option.text = gn;
            select.add(option);
        }
    }
    else {
        sketchup.get_grid_names();
    }
}