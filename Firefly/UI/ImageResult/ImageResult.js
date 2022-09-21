function initUI() {
    sketchup.get_result_files();

    document.getElementById('file_select').addEventListener('change', e => updatePreview());
}

function showImage() {
    let options = {
        'file_name': getElementValue('file_select'),
        'type': getElementValue('type_select'),
        'falsecolor_scale': getElementValue('falsecolor_input'),
        'falsecolor_palette': document.querySelector('[name=falsecolor_radio]:checked').value
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
    }

    for (const rf of resultFiles) {
        let option = document.createElement('option');
        option.text = rf;
        select.add(option);
    }

    updatePreview();
}

function typeChanged() {
    let type = getElementValue('type_select');
    document.getElementById('falsecolor_div').hidden = (type != 'False Color');
    console.log(type);
}

function getElementValue(id) {
    return document.getElementById(id).value
}

function updatePreview(file) {
    if (file == null){
        let file = getElementValue('file_select');
        sketchup.get_preview(file);
    }
    else {
        preview_img = document.getElementById('preview_img');
        preview_img.src = file;
    }
}
