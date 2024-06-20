window.addEventListener('message', function(event) {
    const data = event.data;
    if (data.type === 'updateHud') {
        if (data.postal !== '') {
            document.getElementById('postal-code').innerText = data.postal;
        } else {
            document.getElementById('postal-code').innerText = '';
        }
        if (data.street !== '') {
            document.getElementById('street-name').innerText = data.street;
        } else {
            document.getElementById('street-name').innerText = '';
        }
    }
});
