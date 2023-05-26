class DataProvider
  include Singleton

  attr_accessor :orders

  def initialize
    file = File.read('./data/orders.json')
    @orders = JSON.parse(file).map do |item|
      order_items = item["items"].map do |i|
        OrderItem.new(
          name: i["name"],
          size: i["size"],
          add: i["add"],
          remove: i["remove"]
        )
      end
      Order.new(
        id: item["id"],
        created_at: DateTime.parse(item["createdAt"]),
        state: item["state"],
        items: order_items,
        promotion_codes: item["promotionCodes"],
        discount_code: item["discountCode"]
      )
    end
  end
end