$(document).on('turbolinks:load', function() {
  getAllGists()

  $('.new-answer').on('submit', getNewAnswerGists)
})

const getAllGists = function() {
  const gistLinks = $('.gist-link')

  getContent(gistLinks)
}

const getNewAnswerGists = function() {
  setTimeout(function() {
    const gistLinks = $(`.answers .card:last-child .gist-link`)

    getContent(gistLinks)
  }, 500)
}

const getContent = function(gistLinks) {
  gistLinks.each(function() {
    const linkId = $(this).data('linkId')
    const gistId = $(this).attr('href').split('/').pop()

    $.get('https://api.github.com/gists/' + gistId)
      .done((data) => { formatContent(data.files, linkId) })
      .fail(function() { formatContent(false, linkId) })
  })
}

const formatContent = function(files, linkId) {
  const gistContent = $(`.gist-content[data-link-id="${linkId}"]`)
  gistContent.html('')
  gistContent.removeClass('hidden')

  if (files) {
    $.each(files, (key, value) => {
      gistContent.append(key + '\n').append(value.content + '\n')
    })
  } else {
    gistContent.append('Gist not found')
  }
}
