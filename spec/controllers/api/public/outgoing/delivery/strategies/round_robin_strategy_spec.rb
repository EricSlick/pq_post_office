require 'rails_helper'

RSpec.describe Api::Public::Outgoing::Delivery::Strategies::RoundRobinStrategy do
  let(:subject) { Api::Public::Outgoing::Delivery::Strategies::RoundRobinStrategy.new(adapters: adapters) }
  let(:adapters) do
    Api::Public::Outgoing::Delivery::AdapterManager.new.send(:fetch_adapter_klasses)
  end

  it 'returns an adapter' do
    expect(adapters).to include subject.use_adapter
  end

  it 'picks an adapter round robin style' do
    expect(adapters[0]).to eq subject.use_adapter
    expect(adapters[1]).to eq subject.use_adapter
    expect(adapters[0]).to eq subject.use_adapter
  end
end