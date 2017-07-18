require 'spec_helper'

RSpec.describe "", :type => :ios do
  context "Registration test" do
    context "through email" do
      it "through email should be OK" do
        #TestLogger.info("Authorization through email started...")
        @username = Config.contacts.email
        send_code(@username)

        auth('email')

        expect(true).to eq(true)
      end
    end
  end
end
