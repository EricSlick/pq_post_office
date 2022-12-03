require 'rails_helper'

RSpec.describe Api::Public::Outgoing::Delivery::BalanceManager, type: :api do
  let(:subject) { Api::Public::Outgoing::Delivery::BalanceManager.new(adapters: adapters) }
  let(:adapters) do
    Api::Public::Outgoing::Delivery::AdapterManager.new.send(:fetch_adapter_klasses)
  end

  it 'has a default strategy' do
    default_strategy = Api::Public::Outgoing::Delivery::BalanceManager::DEFAULT_STRATEGY
    expect(subject.strategy).to include Api::Public::Outgoing::Delivery::BalanceManager::STRATEGIES[default_strategy]
  end

  it 'calls the strategy' do
    strategy_klass = subject.strategy_klass
    expect(strategy_klass).to receive(:use_adapter)
    subject.use_adapter
  end
end