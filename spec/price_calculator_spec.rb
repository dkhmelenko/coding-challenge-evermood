require "rails_helper"

describe PriceCalculator do
  it "calculates prices without discounts and promocodes" do
    order = Order.new(id: 1, created_at: DateTime.now, state: "OPEN",
      promotion_codes: [], discount_code: nil, items: [
      OrderItem.new(name: "Salami", size: "Small", add: [], remove: [])
    ])

    price = PriceCalculator.new(order: order).call
    assert_equal 4.2, price
  end

  it "calculates prices with discounts" do
    order = Order.new(id: 1, created_at: DateTime.now, state: "OPEN",
      promotion_codes: [], discount_code: "SAVE5", items: [
      OrderItem.new(name: "Salami", size: "Small", add: [], remove: [])
    ])

    price = PriceCalculator.new(order: order).call
    assert_equal 3.99, price
  end

  it "calculates prices with promocodes" do
    order = Order.new(id: 1, created_at: DateTime.now, state: "OPEN",
      promotion_codes: ["2FOR1"], discount_code: nil, items: [
      OrderItem.new(name: "Salami", size: "Small", add: [], remove: []),
      OrderItem.new(name: "Salami", size: "Small", add: [], remove: [])
    ])

    price = PriceCalculator.new(order: order).call
    assert_equal 4.2, price
  end

  it "calculates prices with discounts and promocodes" do
    order = Order.new(id: 1, created_at: DateTime.now, state: "OPEN",
      promotion_codes: ["2FOR1"], discount_code: "SAVE5", items: [
      OrderItem.new(name: "Salami", size: "Small", add: [], remove: []),
      OrderItem.new(name: "Salami", size: "Small", add: [], remove: [])
    ])

    price = PriceCalculator.new(order: order).call
    assert_equal 3.99, price
  end

  it "calculated price for medium salami pizza" do
    order = Order.new(id: 1, created_at: DateTime.now, state: "OPEN",
      promotion_codes: [], discount_code: nil, items: [
      OrderItem.new(name: "Salami", size: "Medium", add: [], remove: [])
    ])

    price = PriceCalculator.new(order: order).call
    assert_equal 6.0, price
  end

  it "calculated price for large salami pizza" do
    order = Order.new(id: 1, created_at: DateTime.now, state: "OPEN",
      promotion_codes: [], discount_code: nil, items: [
      OrderItem.new(name: "Salami", size: "Large", add: [], remove: [])
    ])

    price = PriceCalculator.new(order: order).call
    assert_equal 7.8, price
  end

  it "calculates price with add on ingredients" do
    order = Order.new(id: 1, created_at: DateTime.now, state: "OPEN",
      promotion_codes: [], discount_code: nil, items: [
      OrderItem.new(name: "Salami", size: "Medium", add: ["Onions", "Olives"], remove: [])
    ])

    price = PriceCalculator.new(order: order).call
    assert_equal 9.5, price
  end

  it "calculates price and remove ingredients doesn't impact price" do
    order = Order.new(id: 1, created_at: DateTime.now, state: "OPEN",
      promotion_codes: [], discount_code: nil, items: [
      OrderItem.new(name: "Salami", size: "Medium", add: [], remove: ["Onions", "Olives"])
    ])

    price = PriceCalculator.new(order: order).call
    assert_equal 6.0, price
  end
end