require 'minitest/autorun'
require 'timeout'
require 'awesome_print'

class CustomerSuccessBalancing
  attr_accessor :sorted_customers,
                :sorted_customer_success,
                :customer_success_away,
                :customer_success_tie
  attr_reader :customer_success_with_most_customers

  def initialize(customer_success, customers, customer_success_away)
    self.sorted_customer_success = customer_success.sort_by { |c| c[:score] }
    self.sorted_customers = customers.sort_by { |c| c[:score] }
    self.customer_success_away = customer_success_away.sort
    self.customer_success_tie = false
  end

  # Returns the id of the CustomerSuccess with the most customers
  def execute
    sorted_customer_success.each do |cs|
      next if customer_success_away.bsearch { |cs_away| cs[:id] <=> cs_away }

      # cs_attended_customers = sorted_customers.select { |c| c[:score] <= cs[:score] }
      i = sorted_customers.bsearch_index { |c| c[:score] > cs[:score] }
      cs_attended_customers = sorted_customers[0...i]
      self.sorted_customers -= cs_attended_customers
      cs[:customers_count] = cs_attended_customers.size
      self.customer_success_with_most_customers = cs
    end

    customer_success_tie? ? 0 : customer_success_with_most_customers[:id]
  end

  private

  def customer_success_with_most_customers=(current_cs)
    @customer_success_with_most_customers ||= { customers_count: 0 }

    if current_cs[:customers_count] > customer_success_with_most_customers[:customers_count]
      @customer_success_with_most_customers = current_cs
      self.customer_success_tie = false
    elsif current_cs[:customers_count] == customer_success_with_most_customers[:customers_count]
      self.customer_success_tie = true
    end
  end

  def customer_success_tie?
    customer_success_tie
  end
end

class CustomerSuccessBalancingTests < Minitest::Test
  def test_scenario_one
    css = [{ id: 1, score: 60 }, { id: 2, score: 20 }, { id: 3, score: 95 }, { id: 4, score: 75 }]
    customers = [{ id: 1, score: 90 }, { id: 2, score: 20 }, { id: 3, score: 70 }, { id: 4, score: 40 }, { id: 5, score: 60 }, { id: 6, score: 10}]

    balancer = CustomerSuccessBalancing.new(css, customers, [2, 4])
    assert_equal 1, balancer.execute
  end

  def test_scenario_two
    css = array_to_map([11, 21, 31, 3, 4, 5])
    customers = array_to_map( [10, 10, 10, 20, 20, 30, 30, 30, 20, 60])
    balancer = CustomerSuccessBalancing.new(css, customers, [])
    assert_equal 0, balancer.execute
  end

  def test_scenario_three
    customer_success = Array.new(1000, 0)
    customer_success[998] = 100

    customers = Array.new(10000, 10)
    
    balancer = CustomerSuccessBalancing.new(array_to_map(customer_success), array_to_map(customers), [1000])

    result = Timeout.timeout(1.0) { balancer.execute }
    assert_equal 999, result
  end

  def test_scenario_four
    balancer = CustomerSuccessBalancing.new(array_to_map([1, 2, 3, 4, 5, 6]), array_to_map([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]), [])
    assert_equal 0, balancer.execute
  end

  def test_scenario_five
    balancer = CustomerSuccessBalancing.new(array_to_map([100, 2, 3, 3, 4, 5]), array_to_map([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]), [])
    assert_equal balancer.execute, 1
  end

  def test_scenario_six
    balancer = CustomerSuccessBalancing.new(array_to_map([100, 99, 88, 3, 4, 5]), array_to_map([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]), [1, 3, 2])
    assert_equal balancer.execute, 0
  end

  def test_scenario_seven
    balancer = CustomerSuccessBalancing.new(array_to_map([100, 99, 88, 3, 4, 5]), array_to_map([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]), [4, 5, 6])
    assert_equal balancer.execute, 3
  end

  def array_to_map(arr)
    out = []
    arr.each_with_index { |score, index| out.push({ id: index + 1, score: score }) }
    out
  end
end

Minitest.run
