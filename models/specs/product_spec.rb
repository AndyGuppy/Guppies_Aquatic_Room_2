require('minitest/autorun')
require('minitest/rg')
require_relative('../product_class')


class ProductSpec < MiniTest::Test

  def test_can_create_product
    product1 = Product.new({'specie' => 'White Cloud Mountain Minnow','latin_name' => 'Tanichthys albonubes','image' => './images/white_cloud_minnow.jpg','price' => 1.35,'quantity' => 30})
    actual = product1.class
    expected = Product
    assert_equal(expected, actual)
  end

  def test_can_save_product_to_database
    product1 = Product.new({'specie' => 'White Cloud Mountain Minnow','latin_name' => 'Tanichthys albonubes','image' => './images/white_cloud_minnow.jpg','price' => 1.35,'quantity' => 30})
    product1.save()
    actual = product1.specie
    expected = 'White Cloud Mountain Minnow'
    assert_equal(expected, actual)
  end

  def test_can_get_product_id_from_specie
    product1 = Product.new({'specie' => 'White Cloud Mountain Minnow','latin_name' => 'Tanichthys albonubes','image' => './images/white_cloud_minnow.jpg','price' => 1.35,'quantity' => 30})
    product1.save()
    Product.delete_duplicates()
    actual = Product.get_product_id('White Cloud Mountain Minnow')
    expected = product1.id
    assert_equal(expected, actual)
  end

  def test_can_get_product_price
    product1 = Product.new({'specie' => 'White Cloud Mountain Minnow','latin_name' => 'Tanichthys albonubes','image' => './images/white_cloud_minnow.jpg','price' => 1.35,'quantity' => 30})
    product1.save()
    Product.delete_duplicates()
    actual = product1.price
    expected = 1.35
    assert_equal(expected, actual)
  end

  def test_can_delete_duplicate_products
    product1 = Product.new({'specie' => 'White Cloud Mountain Minnow','latin_name' => 'Tanichthys albonubes','image' => './images/white_cloud_minnow.jpg','price' => 1.35,'quantity' => 30})
    product1.save()
    product2 = Product.new({'specie' => 'White Cloud Mountain Minnow','latin_name' => 'Tanichthys albonubes','image' => './images/white_cloud_minnow.jpg','price' => 1.35,'quantity' => 30})
    product2.save()
    Product.delete_duplicates()
    actual = Product.all_instances('White Cloud Mountain Minnow').count
    expected = 1
    assert_equal(expected, actual)
  end

end