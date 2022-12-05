require_relative 'balance_manager'

module Api
  module Public
    module Outgoing
      module Delivery
        # This acts as the Internal Facing API for sending a message
        # Based on the strategy used, it picks an adapter that will do the actual delivery of the message
        # It creates a Sidekiq job to handle the calling of the adapter to send a message
        class AdapterManager
          def deliver(message)
            picked_adapter = adapter
            if picked_adapter.nil?
              Rails.logger.info("Delivery::AdapterManager: No Available adapters: (all adapters failed?)")
              message.update(status: Message::STATUS[:undeliverable], status_info: "Unable to send Message: No available adapters.")
              return
            end
            adapters_tried = message.adapters_tried || []
            adapters_tried << picked_adapter
            message.update(adapter: picked_adapter, adapters_tried: adapters_tried)
            Api::Public::Outgoing::Delivery::MessageDeliveryJob.perform_async(message.uuid)
          end

          # chooses another adapter not in the skip_adapters list
          def deliver_without(skip_adapters = [], message)
            @skip_adapters = skip_adapters
            deliver(message)
          end

          private

          def adapter
            fetch_adapter_klasses
            BalanceManager.new(adapters: @adapters).use_adapter
          end

          def fetch_adapter_klasses
            return @adapters if @adapters
            @adapters = []
            autoload_dir = File.join(Rails.root, "app","controllers", "api", "public", "outgoing", "delivery", "adapters")
            Dir.glob(File.join(autoload_dir, "**", "*_adapters_controller.rb")).collect do |file_path |
              file_path.slice!("#{Rails.root}/app/controllers/")
              klass_name = file_path.split('/').map do |name|
                name.camelize
              end.join('::')
              klass_name.slice!('.rb')
              @adapters << klass_name.constantize unless (@skip_adapters || []).include?(klass_name)
            end
            @adapters
          end
        end
      end
    end
  end
end
