import consumer from "./consumer"

consumer.subscriptions.create("CommentsChannel", {
  connected() {

  },

  disconnected() {

  },

  received(data) {
    var userId = $('#user-id').data('userId')

    if (data.author_id != userId) {
      $('#' + data.commentable).find('.comments').append(data.html)
    }
  }
});
