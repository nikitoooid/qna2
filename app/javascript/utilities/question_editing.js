document.addEventListener('click', function (e) {
    if (e.target.classList.contains('edit-question-link')) {

        e.preventDefault()

        e.target.classList.add('hidden')

        let form = document.getElementById('edit-question')
        if (form) form.classList.remove('hidden')
    }
})