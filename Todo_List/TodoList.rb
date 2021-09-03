class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end

  def ==(otherTodo)
    title == otherTodo.title &&
    description == otherTodo.description &&
    done == otherTodo.done
  end
end

class TodoList 
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(todo)
    if todo.class == Todo
      todos << todo
    else
      raise TypeError, 'Can only add Todo objects'
    end
  end

  alias_method :<<, :add

  def size
    todos.size
  end

  def first
    todos.first
  end

  def last
    todos.last
  end

  # def to_a
  #   todos.map { |todo| todo.to_s }
  # end

  def to_a          # This is the definition of to_a proposed from LS. I opted for str representation of object 
    todos.clone
  end

  def done?
    todos.all? { |todo| todo.done? }
  end

  def item_at(idx)
    if idx > todos.size
      raise IndexError, 'The given index does not exist'
    else
      todos[idx]
    end
  end

  def mark_done_at(idx)
    if idx > todos.size
      raise IndexError, 'The given index does not exist'
    else
      todos[idx].done!
    end
  end

  def mark_undone_at(idx)
    if idx > todos.size
      raise IndexError, 'The given index does not exist'
    else
      todos[idx].undone!
    end
  end

  def done!
    todos[0..-1].each { |todo| todo.done! }
  end

  def shift
    todos.delete_at(0)
  end

  def pop
    todos.delete_at(-1)
  end

  def remove_at(idx)
    if idx > todos.size
      raise IndexError, 'The given index does not exist'
    else
      todos.delete_at(idx)
    end
  end

  # def to_s     # This was my first working approach
  #   txt = "---- #{title} ----\n"
  #   txt << todos.map(&:to_s).join("\n")
  #   txt
  # end

  def to_s
    <<~OUTPUT.chomp
    ---- #{title} ----
    #{todos.map(&:to_s).join("\n")}
    OUTPUT
  end

  # def each                
  #   idx = 0
  #   while idx < self.size
  #     yield(todos[idx])
  #     idx += 1
  #   end
  # end

  def each                   # This version is shorter but relies on `Array#each`...why not?!
    todos.each do |todo|
      yield(todo)
    end
    self                     # The inclusion of self ensures that the return val from each is the original calling object
  end

  def select
    new = TodoList.new(title)
    todos.each do |todo|
      new << todo if yield(todo)
    end
    new
  end

  def find_by_title(title)
    select { |todo| todo.title == title }.first
  end

  def all_done
    select { |todo| todo.done? }
  end

  def all_not_done
    select { |todo| !todo.done? }
  end

  def mark_done(title)
    task = find_by_title(title)
    task ? task.done! : (raise ArgumentError, 'Task not found')
  end

  def mark_all_done
    each { |todo| todo.done! }
  end

  def mark_all_undone
    each { |todo| todo.undone! }
  end

  private
  attr_reader :todos
end

# ---- CLIENT CODE ----
=begin
todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")
list = TodoList.new("Today's Todos")

# ---- Adding to the list -----

# add
list.add(todo1)               # adds todo1 to end of list, returns list
list.add(todo2)               # adds todo2 to end of list, returns list
# list.add(1)                 # raises TypeError with message "Can only add Todo objects"

# <<                          # same behavior as add (alias_method)
# list << 'hello'               # raises TypeError
list << todo3                 # adds todo3 to end of list, returns list

# ---- Using defined iterators methods ----

# each
list.each do |todo|
  puts todo                   # calls Todo#to_s
end

# select

list.mark_done_at(1)          # to make sure the select method can sometime evaluates to true 

results = list.select { |todo| todo.done? } 
puts results.inspect

# ---- Interrogating the list -----

# size
puts list.size                # returns 3

# first
puts list.first               # returns todo1, which is the first item in the list

# last
puts list.last                # returns todo3, which is the last item in the list

#to_a
p list.to_a                   # returns an array of all items in the list

#done?
p list.done?                  # returns true if all todos in the list are done, otherwise false

# ---- Retrieving an item in the list ----

# puts list.item_at             # raises ArgumentError
puts list.item_at(1)          # returns 2nd item in list (zero based index)
# puts list.item_at(100)        # raises IndexError

# ---- Marking items in the list -----

# mark_done_at
# list.mark_done_at             # raises ArgumentError
list.mark_done_at(1)          # marks the 2nd item as done
list.mark_done_at(2)
# list.mark_done_at(100)        # raises IndexError

# # mark_undone_at
# list.mark_undone_at           # raises ArgumentError
list.mark_undone_at(2)        # marks the 2nd item as not done,
# list.mark_undone_at(100)      # raises IndexError

# done!
list.done!                    # marks all items as done

# ---- Deleting from the list -----

# puts list.shift               # removes and returns the first item in list

# puts list.pop                 # removes and returns the last item in list

# puts list.remove_at(1)        # removes and returns the 2nd item
# list.remove_at(100)           # raises IndexError

# ---- Outputting the list -----

list.to_s                     # returns string representation of the list

# ---- Extra methods ----

# find task by title
p list.find_by_title('Clean room')     # returns todo obj which title coincides with argument
p list.find_by_title('Go shopping')    # return nil if no todo obj title coincides with arg

# retrieve only done tasks
p list.all_done

# retrieve only not done tasks
p list.all_not_done

# find by title and mark as done
list.mark_done('Go to gym')

# mark all todos as done
list.mark_all_done

# mark all todos as undone
list.mark_all_undone
=end

=begin
todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")
list = TodoList.new("Today's Todos")

list.add(todo1)        
list.add(todo2)       
list << todo3

# p return_val =list.select { |todo| todo.title == "Buy milk" } 
# 
# p list.find_by_title('Clean room')
puts list.to_s
list << 'hello'
=end