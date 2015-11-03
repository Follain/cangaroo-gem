require 'rails_helper'

module Cangaroo
  RSpec.describe HandleRequest do
    let(:connection) { create :cangaroo_connection }
    let(:command) { HandleRequest.new(json_payload, connection.key, connection.token) }

    describe "call" do
      before do
        command.call
      end

      context "when success" do
        let(:json_payload) { load_fixture('json_payload_ok.json') }

        it "authenticates connection" do
          expect(command.connection).to be_present
        end

        it "validates json schema" do
          expect(command.valid_json?).to be true
        end

        it 'saves items' do
          expect(command.items).not_to be_empty
        end
      end

      context "when failure" do
        let(:json_payload) { load_fixture('json_payload_no_id.json') }

        it "returns false" do
          expect(command.result).to be false
        end

        it "authenticates connection" do
          expect(command.connection).to be_present
        end

        it "populates errors for json schema" do
          expect(command.valid_json?).to be false
        end

        it 'does not save items' do
          expect(command.items).to be_empty
        end
      end

    end
  end
end
