class SlotColum
  attr_reader :column_num
    
  def initialize
    @number = (1..7).to_a
    @column_num = []
    3.times{@column_num.push(@number.slice!(rand(@number.length)))}
  end
end

