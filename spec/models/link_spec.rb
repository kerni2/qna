require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it "gist? should be true" do
    @link = Link.new()
    @link.name = "MyLink"
    @link.url = "https://gist.github.com/kerni2/36e1d17e7764bb003727496feb417c1d"
    expect(@link.gist?).to be true
  end

end
