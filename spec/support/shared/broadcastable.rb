shared_examples_for 'Broadcastable' do
  describe 'broadcasting' do
    it "matches with stream name" do
      expect {
        ActionCable.server.broadcast(channel, text: 'Hello!')
      }.to have_broadcasted_to(channel)
    end

    it "matches with message" do
      expect {
        ActionCable.server.broadcast(channel, text: 'Hello!')
      }.to have_broadcasted_to(channel).with(text: 'Hello!')
    end
  end
end
