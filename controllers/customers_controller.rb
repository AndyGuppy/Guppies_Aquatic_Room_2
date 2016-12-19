require( 'sinatra' )
require( 'pry-byebug')
require( 'sinatra/contrib/all' ) if development?
require_relative( '../models/customer_class.rb' )

#get all customers
get '/customers' do
  @customers = Customer.all()
  erb ( :"customers/index" )
end

#new customer form
get '/customers/new' do
erb( :"customers/new" )

end

#actually make the customer
post '/customers' do
@customer = Customer.new(params)
@customer.save()
redirect to('/customers')
end

#not having a customer view

#edit customer form
get '/customers/:id/ammend' do
@customer = Customer.find(params[:id])
erb(:"customers/ammend")
end

#update the customer by id ( PUT request)
post '/customers/:id' do
  Customer.update(params)
  redirect to('/customers')

end

#delete a pizza by id ( DELETE request)
post '/customers/:id/remove' do
  id = params[:id]
  @customer = Customer.destroy(id)
  redirect to('/customers')
end