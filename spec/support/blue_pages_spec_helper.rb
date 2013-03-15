module BluePages::SpecHelper
  def self.stub_message_maker
    MessageMaker.stub :make_message
  end

  def root
    @root ||= Category.root
  end
end
