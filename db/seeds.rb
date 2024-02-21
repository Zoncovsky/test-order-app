user = User.create!(
  first_name: 'John',
  last_name: 'Doe',
  email: 'john@example.com'
)

10.times do
  order = Order.create!(
    price: rand(10.0..100.0),
    quantity: rand(1..10),
    order_type: Order.order_type.buy,
    user: user
  )
end

10.times do
  order = Order.create!(
    price: rand(10.0..100.0),
    quantity: rand(1..10),
    order_type: Order.order_type.sell,
    user: user
  )
end
