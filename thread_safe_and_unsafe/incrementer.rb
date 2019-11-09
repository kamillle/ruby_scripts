class Incrementer
  @@class_variable = 0

  def self.call
    @class_instance_variable = 0
    new.call

    @class_instance_variable += 1
    puts 'class_instace_variable'
    puts @class_instance_variable
  end

  def initialize
    @instance_variable = 0
  end

  def call
    @@class_variable += 1
    @instance_variable += 1

    puts 'class_variable'
    puts @@class_variable
    puts 'instance_variable'
    puts @instance_variable
  end
end

threads = 10.times.map do
  Thread.new do
    Incrementer.call
  end
end

threads.each(&:join)
