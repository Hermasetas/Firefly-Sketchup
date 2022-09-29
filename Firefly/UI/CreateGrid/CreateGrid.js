function initUI() {

}

function updateFaceLabel(face_id) {
    if (face_id) {
        document.getElementById('face_label').innerText = 'FaceID: ' + face_id;
        document.getElementById('run_button').disabled = false;
    }
    else {
        document.getElementById('face_label').innerText = 'Please select a single face';
        document.getElementById('run_button').disabled = true;
    }
}

function createGrid() {
    face_id = document.getElementById('face_label').innerText.substring(8)
    spacing = getElementValue('spacing_input');
    height = getElementValue('height_input');

    sketchup.create_grid(face_id, spacing, height);
}

function getElementValue(id) {
    return document.getElementById(id).value;
}