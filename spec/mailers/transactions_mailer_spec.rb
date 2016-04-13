require "rails_helper"

RSpec.describe TransactionsMailer, type: :mailer do
  describe "export_transactions" do
    let(:mail) { TransactionsMailer.export_transactions }

    it "renders the headers" do
      expect(mail.subject).to eq("Export transactions")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["budget@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
