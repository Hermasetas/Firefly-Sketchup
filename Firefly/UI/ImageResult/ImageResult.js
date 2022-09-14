function initUI() {
    sketchup.get_result_files();
}

function showImage() {
    let options = {
        'file_name': getElementValue('file_select'),
        'type': getElementValue('type_select')
    };

    sketchup.create_image(options);
}

function updateFileSelect(resultFiles) {
    let select = document.getElementById('file_select');
    
    for (_ in select.options) {
        select.remove(0);
    }

    if (resultFiles.length == 0) {
        let option = document.createElement('option');
        option.text = 'No result files found';
        select.add(option);

        document.getElementById('run_button').disabled = true;
    }

    for (const rf of resultFiles) {
        let option = document.createElement('option');
        option.text = rf;
        select.add(option);
    }
}

function getElementValue(id) {
    return document.getElementById(id).value
}