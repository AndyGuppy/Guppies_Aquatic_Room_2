require('minitest/autorun')
require('minitest/rg')
require_relative('../receipt_class')


class ReceiptSpec < MiniTest::Test

  def test_can_create_receipt
    receipt1 = Receipt.new({'customer_id' => 2,'product_id' => 1,'purchase_type' => 'Auction','purchase_time' => Time.now,'delivery_type' => 'collect'})
    actual = receipt1.class
    expected = Receipt
    assert_equal(expected, actual)
  end

  def test_can_save_receipt_to_database
    receipt1 = Receipt.new({'customer_id' => 2,'product_id' => 1,'purchase_type' => 'Auction','purchase_time' => Time.now,'delivery_type' => 'collect'})
    receipt1.save()
    actual = receipt1.customer_id
    expected = 2
    assert_equal(expected, actual)
  end


  def test_can_delete_receipt_from_database
    receipt1 = Receipt.new({'customer_id' => 2,'product_id' => 1,'purchase_type' => 'Auction','purchase_time' => Time.now,'delivery_type' => 'collect'})
    receipt1.save()
    actual = receipt1.delete()
    expected = 'Deleted'
    assert_equal(expected, actual)
  end

end