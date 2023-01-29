class NewAnswerNotificationService
  def send_notification(answer)
    subscriptions = Subscription.where(question: answer.question)
    subscriptions.find_each do |subscription|
      NewAnswerMailer.notify(subscription.user, answer).deliver_later
    end
  end
end
