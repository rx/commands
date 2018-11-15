require 'spec_helper'
require 'voom/commands/base'

RSpec.describe Voom::Commands::Base do
  class TestCommand < Voom::Commands::Base
    def perform
    end
  end

  describe 'self.call' do
    context 'no params' do
      it 'succeeds' do
        expect(TestCommand.call!.success?).to eq(true)
      end
    end

    context 'block' do
      it 'overrides response' do
        expect(TestCommand.call! {|_, cmd| cmd.fail}.success?).to eq(false)
      end

      it 'recieves response' do
        expect(TestCommand.call! {|r1, _| r1.success?}.success?).to eq(true)
      end
    end
  end
end
