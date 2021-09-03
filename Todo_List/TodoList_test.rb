require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'todolist'

class TodoListTest < MiniTest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    shifted_item = @list.shift
    assert_equal(@todo1, shifted_item)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_pop
    popped_item = @list.pop
    assert_equal(@todo3, popped_item)
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_done
    assert_equal(false, @list.done?)
  end

  # def test_done   # this was my first approach that works
  #   assert_equal(@todos.all? { |todo| todo.done == true }, @list.done?)
  # end

  def test_add_raise_error
    arg = [1,'hi',[1,2,3], {a: 'r'}].sample # collection of random objects, other than Todo object
    assert_raises(TypeError) { @list.add(arg) }
  end

  def test_shovel_add_to_list
    @list << Todo.new("some task")
    assert_equal(4, @list.size)
  end

  def test_add_add_to_list
    @list.add(Todo.new("some task"))
    assert_equal(4, @list.size)
  end

  def test_item_at_rise_error   # when checking for exception... 
    assert_raises(IndexError) { @list.item_at(4) } # ...we test the exception scenario 
    assert_equal(@todo1, @list.item_at(0)) # ...and the no exception scenario 
  end

  def test_mark_done_at_rise_error
    assert_raises(IndexError) { @list.mark_done_at(4) }
    @list.mark_done_at(0)
    assert_equal(true, @todo1.done?)
    assert_equal(false, @todo2.done?)
  end

  def test_mark_undone_at_rise_error 
    assert_raises(IndexError) { @list.mark_undone_at(4) }
    @list.mark_done_at(0)
    assert_equal(true, @todo1.done?)
    @list.mark_undone_at(0)
    assert_equal(false, @todo1.done?)
  end

  def test_done
    @list.done!
    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo3.done?)
    assert_equal(true, @list.done?)
  end

  def remove_at_rise_error
    assert_raises(IndexError) { @list.remove_at(4) }
    assert_equal(@todo1, @list.remove_at(0))
    assert_equal(@todo2, @list.remove_at(1))
    assert_equal(@todo3, @list.remove_at(2))
  end
 
  def test_to_s
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT
    assert_equal(output, @list.to_s)
  end

  def test_to_s_updated_with_done_todo
    @todo3.done!
    @list.mark_done_at(0)
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [ ] Clean room
    [X] Go to gym
    OUTPUT
    assert_equal(output, @list.to_s)
  end

  def test_to_s_updated_with_all_tasks_done
    @list.done!
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT
    assert_equal(output, @list.to_s)
  end

  def test_that_each_iterates
    first_iteration = nil
    @list.each do |todo|
      first_iteration = todo
      break
    end
    assert_equal(@todo1, first_iteration)
  end

  def test_that_each_returns_self
    return_val = @list.each { }
    assert_equal(@list, return_val)
  end

  def test_that_select_returns_new_object
    return_val = @list.select { }
    refute_equal(@list.object_id, return_val.object_id)
  end

  def test_select
    new_list = TodoList.new(@list.title)
    new_list << @todo1
    assert_equal(new_list.to_s, @list.select { |todo| todo.title == "Buy milk" }.to_s)
  end

  def test_find_by_title_returns_title
    found_title = @list.find_by_title("Buy milk")    
    found_nil = @list.find_by_title("Go shopping")
    assert_equal(@todo1, found_title)
    assert_equal(nil, found_nil)
  end

end