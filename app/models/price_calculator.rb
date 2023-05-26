class PriceCalculator
  attr_reader :config, :order

  def initialize(order:)
    @config = YAML.load_file('./data/config.yml')
    @order = order
  end

  def call
    price = calculate_pizza_price

    price = price - get_promo_codes_discount
    price = price - get_discount(price)

    price.round(2)
  end

  private

  def calculate_pizza_price
    prices = order.items.map do |item|
      base_price = config["pizzas"][item.name].to_f
      size_multiplier = config["size_multipliers"][item.size].to_f
      ingredient_prices = item.add.map do |ing|
        config["ingredients"][ing].to_f * size_multiplier
      end
      base_price * size_multiplier + ingredient_prices.sum
    end
    prices.sum
  end

  def get_promo_codes_discount
    unless order.promotion_codes.empty?
      promos = order.promotion_codes.map do |promo|
        promotion = config["promotions"][promo]
        target = promotion["target"]
        target_size = promotion["target_size"]
        from = promotion["from"]
        to = promotion["to"]

        found_items = order.items.filter {|el| el.name == target && el.size == target_size}
        if found_items.count >= from
          item = found_items[0]
          base_price = config["pizzas"][item.name].to_f
          size_multiplier = config["size_multipliers"][item.size].to_f
          item_price = base_price * size_multiplier

          discount = item_price * (found_items.count / from).to_i * to
          discount
        end
      end
      price_reduce = promos.compact.sum
      price_reduce
    else
      0
    end
  end

  def get_discount(price)
    if order.discount_code
      discount = config["discounts"][order.discount_code]["deduction_in_percent"]
      price * discount.to_f / 100.0
    else
      0
    end
  end
end