require( 'sinatra' )
require( 'pry-byebug')
require( 'sinatra/contrib/all' ) if development?
require_relative( '../models/customer_class.rb' )
require_relative( '../models/product_class.rb' )
require_relative( '../models/basket_class.rb' )

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

#Find Customer while retaining product
post '/customers/:pid/custcheck' do
  @product = Product.find(params[:pid])
  @customer = Customer.get_customer_id(params[:name])

  if @customer == "Customer Not Found"
    erb(:"customers/nomember")
  else
    @customer = Customer.find(@customer)
    erb(:"customers/buy")
  end

end

#customer puts product in basket
post '/customers/:pid/:cid/buy' do
  @customer = Customer.find(params[:cid])
  @product = Product.find(params[:pid])
  @quantity = params[:quantity]
#build record to send to basket
  @val = {'customer_id' => params[:cid].to_i,'specie' => @product.specie,'price' => @product.price,'quantity' => params[:quantity].to_i}
#Fire record to basket
  @basket = Basket.new(@val)
  @basket.save()
#keep hold of basket contents to pass back
  @basket = Basket.all(params[:cid].to_i)
  @total = 0
#add total of contents of basket
  for basket in @basket
    @total += (basket.price.to_f * basket.quantity.to_i)
  end
  erb(:"customers/basket")
end

#delete a customer by id
post '/customers/:id/remove' do
  id = params[:id]
  @customer = Customer.destroy(id)
  redirect to('/customers')
end

#empty the basket
post '/customers/:id/cancel' do
  id = params[:id]
  @basket = Basket.delete(id)
  redirect to('/')
end

#find customer to retrieve basket
get '/customers/find' do
  erb( :"customers/finalise" )
end

#find customer to retrieve basket
post ('/customers/custcheck') do 
  @customer = Customer.get_customer_id(params[:name])

  if @customer == "Customer Not Found"
    #Customer is not in the club ;-) send them to join
    erb(:"customers/nomember")
  else
    #Customer is in the club
    @customer = Customer.get_customer_id(params[:name])
    #create customer instance
    @customer = Customer.find(@customer)
    #basket records for this customer
    @basket = Basket.all(@customer.id)
    @total = 0.0
    #Total of customers basket
    for basket in @basket
      @total += (basket.price.to_f * basket.quantity.to_i)
    end
      erb( :"customers/basket" )
  end
end

#find customer basket detais by customer name
get '/customers/mybasket' do
  @customer = Customer.get_customer_id(params[:name])
  #create customer instance
  @customer = Customer.find(@customer)
  #create customers basket instance
  @basket = Basket.all(@customer.id)
  @total = 0.0
  #get the total for basket
  for basket in @basket
    @total += (basket.price.to_f * basket.quantity.to_i)
  end
    erb( :"customers/basket" )
end

#edit customer form
get '/customers/:id/ammend' do
  @customer = Customer.find(params[:id])
  erb(:"customers/ammend")
end

#update the customer by id
post '/customers/:id' do  
  Customer.update(params)
  redirect to('/customers')
end

#Customer pays - still to comment in detail
post '/customer/:cid/pay' do
  @customer_id = params[:cid]
  @basket = Basket.all(@customer_id)
  @total = 0.0
  @customer = Customer.find(@customer_id)
  for basket in @basket
    Product.reduced_by(basket.specie,basket.quantity)
    @total += (basket.price.to_f * basket.quantity.to_i)
  end
  @final_balance = (@customer.funds.to_f - @total.to_f)
  Customer.reduced_by(@customer_id,@total.to_f)
  @timestamp = Time.now
  Basket.delete(@customer_id)
  erb(:"customers/reciept")
end