require "../../../spec_helper"

describe Events::Handlers::KeyPressed do
  context "when handling a KeyPressed event" do
    it "returns true to continue the handler chain" do
      handler = Events::Handlers::KeyPressed.new
      event = Events::KeyPressed.new

      handler.handle(event).should be_true
    end
  end
end
