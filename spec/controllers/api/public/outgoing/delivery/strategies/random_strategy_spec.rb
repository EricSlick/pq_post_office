require 'rails_helper'

RSpec.describe Api::Public::Outgoing::Delivery::Strategies::RandomStrategy, type: :api do
  let(:subject) { Api::Public::Outgoing::Delivery::Strategies::RandomStrategy.new(adapters: adapters) }
  let(:adapters) do
    Api::Public::Outgoing::Delivery::AdapterManager.new.send(:fetch_adapter_klasses)
  end

  it 'returns an adapter' do
    expect(adapters).to include subject.use_adapter
  end

  it 'picks an adapter randomly' do
    expect(subject).to receive(:rand).and_return(0)
    subject.use_adapter
  end
end