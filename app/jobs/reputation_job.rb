class ReputationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Reputation.calculate(answer)
  end
end
