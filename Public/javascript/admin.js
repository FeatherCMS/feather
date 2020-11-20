document.addEventListener("keydown", function(e) {
    if ( (window.navigator.platform.match("Mac") ? e.metaKey : e.ctrlKey) && e.keyCode == 83 ) {
        e.preventDefault();
        document.forms[0].submit()
    }
}, false);

window.addEventListener('load', function() {
    var elem = document.getElementById('notification');
    if (elem != null) {
        setTimeout(function() {
            elem.classList.toggle('fade');
            //elem.parentNode.removeChild(elem);
        }, 1500);
    }
});

function chooseImage() {
    document.getElementById('imageDelete').value = false;
    document.getElementById('image').click();
}
function removeImage() {
    document.getElementById('image').value = null;
    document.getElementById('imageDelete').value = true;
    
    const placeholder = document.getElementById('placeholder');
    placeholder.classList.remove('hidden');

    const element = document.getElementById('uploaded-image');
    if (element !== null) {
        element.parentNode.removeChild(element);
    }
}

const imageElement = document.getElementById("image")
if (imageElement !== null) {
    imageElement.onchange = function(event) {
        const placeholder = document.getElementById('placeholder');
        placeholder.classList.add('hidden');

        const file = event.target.files[0];
        const blobURL = URL.createObjectURL(file);
        let element = document.getElementById('uploaded-image');
        if (element === null) {
            var newElement = document.createElement("img");
            newElement.id = 'uploaded-image';
            const sibling = document.getElementById('choose-button');
            sibling.parentNode.insertBefore(newElement, sibling);
            element = newElement
        }
        element.src = blobURL;
    }
}
