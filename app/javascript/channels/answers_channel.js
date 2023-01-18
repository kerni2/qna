import consumer from "./consumer"

$(document).on('turbolinks:load', function() {

  consumer.subscriptions.create({ channel: "AnswersChannel", id: gon.question_id }, {
    connected() {
    },

    disconnected() {
    },

    received(data) {
      var userId = $('#user-id').data('userId')

      if (userId != data.author_id){
        $('.answers').append(data.html)
      }
    }
  });
})
