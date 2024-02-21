class Order < ApplicationRecord
	extend Enumerize
	include AASM

	BUY_THRESHOLD = 50
	SELL_THRESHOLD = 49
	USER_ID = User.last

	belongs_to :user

	scope :completed_buy_orders, -> { where(order_type: :buy, status: :completed)}
	scope :completed_sell_orders, -> { where(order_type: :sell, status: :completed)}
	scope :cancelled_order, -> { where(status: :cancelled) }
	scope :total_completed_orders_quantity, -> do
		joins(:user)
			.where(users: { id: USER_ID })
			.where(status: 'completed')
			.sum(:quantity)
	end

	enumerize :order_type,
	  in: %i[
	    buy
	    sell
	  ],
	  scope: true,
	  predicates: true

	aasm :status, no_direct_assignment: true do
    state :pending, initial: true
    state :completed, :cancelled

    event :make_completed do
      transitions from: :pending, to: :completed
    end

    event :cancel do
      transitions from: %i[pending, completed], to: :cancelled
    end
  end

	def self.process_order(order)
    begin
      if order.order_type.buy? && order.price < BUY_THRESHOLD
        order.make_completed!
      elsif order.order_type.sell? && order.price > SELL_THRESHOLD
        order.make_completed!
      else
        order.cancel!
      end
    rescue => e
      Rails.logger.error "Error processing order: #{e.message}"
    end
  end
end
