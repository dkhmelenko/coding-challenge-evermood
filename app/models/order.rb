class Order

  attr_reader :id, :created_at, :items, :promotion_codes, :discount_code
  attr_accessor :state

  def initialize(id:, created_at:, state:, items:, promotion_codes:, discount_code:)
    @id = id
    @created_at = created_at
    @state = state
    @items = items
    @promotion_codes = promotion_codes
    @discount_code = discount_code
  end

  def total_price
    @price_calculator ||= PriceCalculator.new(order: self)
    @price_calculator.call.round(2)
  end
end
