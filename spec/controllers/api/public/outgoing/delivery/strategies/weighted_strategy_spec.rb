require 'rails_helper'

RSpec.describe Api::Public::Outgoing::Delivery::Strategies::WeightedStrategy, type: :api do
  let(:subject) { Api::Public::Outgoing::Delivery::Strategies::WeightedStrategy.new(adapters: adapters) }
  let(:adapters) do
    Api::Public::Outgoing::Delivery::AdapterManager.new.send(:fetch_adapter_klasses)
  end

  it 'returns an adapter' do
    expect(adapters).to include subject.use_adapter
  end

  context 'default weighting' do
    it 'picks sets up weighted_adapters to match the weighted values' do
      expect(subject).to receive(:rand).and_return(rand(0..10))
      subject.use_adapter
      expect(subject.weighted_adapters.length).to eq 10
      expect(subject.weighted_adapters[0]).to eq adapters[0]
      expect(subject.weighted_adapters[2]).to eq adapters[0]
      expect(subject.weighted_adapters[3]).to eq adapters[1]
      expect(subject.weighted_adapters[9]).to eq adapters[1]
    end
  end
end