document.addEventListener('click', function (e) {
    if (e.target.classList.contains('edit-answer-link')) {
        e.preventDefault()

        e.target.classList.add('hidden')

        let form = document.getElementById(`edit-answer-${e.target.dataset.answerId}`)
        if (form) form.classList.remove('hidden')
    }
})