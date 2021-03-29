require './lib/slotmachine_slot_column'

class Game
  # 賭けることができるコインの枚数
  POSSIBLE_STAKE_COIN = [10, 30, 50]
    
  def initialize(amount)
    @remaining_amount = amount
    ask_stake
  end
  
  # 賭け金を指定
  def ask_stake
    # リスタートのために諸々初期化
    @column_count = 0
    @create_columns = []
    @consecutive_num = []
    
    puts "-----------------"
    puts "残りコイン数:#{@remaining_amount}"
    puts "何コイン入れますか？\n1(10コイン)2(30コイン)3(50コイン)4(やめておく)"
    puts "-----------------"
    @selected_stake = (gets.chomp).to_i
    case @selected_stake
      # 賭け金が設定されたら
    when 1,2,3
      check_enough_money
      #「何もしない」を指定したら 
    when 4
      puts "Bye Bye..."
      return
      # 期待していない文字が入力されたら
    else
      print "\e[31m"
      puts "0~3の数字を入力してください"
      print "\e[0m"
      ask_stake
    end
  end

  # 残り金額が賭け金より多いか判定
  def check_enough_money
    if @remaining_amount >= POSSIBLE_STAKE_COIN[@selected_stake - 1]
      @remaining_amount -= POSSIBLE_STAKE_COIN[@selected_stake - 1]
      start_game
      # 賭け金より残り金額が少なかったら
    else
      print "\e[31m"
      puts "コインが足りません"
      print "\e[0m"
      ask_stake
    end
  end

  # スロット回転
  def start_game
    puts "エンターを3回押しましょう!"
    3.times do
      gets
      puts "-----------------"
      @column_count += 1
      # SlotColumnインスタンス3つ生成
      @create_columns.push(SlotColum.new)
      create_columns
    end
    check_result
  end

  # スロット表示
  def create_columns
    case @column_count
      # enter1回目
    when 1
      3.times do |i|
        puts "|#{@create_columns[0].column_num[i]}|||"
      end
      # enter2回目
    when 2
      3.times do |i|
        puts "|#{@create_columns[0].column_num[i]}|#{@create_columns[1].column_num[i]}||"
      end
      # enter3回目
    when 3
      3.times do |i|
        puts "|#{@create_columns[0].column_num[i]}|#{@create_columns[1].column_num[i]}|#{@create_columns[2].column_num[i]}|"
      end
    end
  end

  # チェックする場所を指定
  def check_result
    # 横
    3.times do |i|
      is_match(@create_columns[0].column_num[i],@create_columns[1].column_num[i],@create_columns[2].column_num[i])
    end
    # ななめ
      is_match(@create_columns[0].column_num[0],@create_columns[1].column_num[1],@create_columns[2].column_num[2])
      is_match(@create_columns[0].column_num[2],@create_columns[1].column_num[1],@create_columns[2].column_num[0])
    show_result
  end

  # 数字が揃っているかチェック
  def is_match(num1, num2, num3)
    if num1 == num2 && num1 == num3
      # 揃っていたらその数字を配列に追加
      @consecutive_num.push(num1)
    end
  end

  def show_result
    # 揃っている数字があったら
    if @consecutive_num.length > 0
      @add_score = POSSIBLE_STAKE_COIN[@selected_stake - 1] * 5
      @remaining_amount += @add_score*@consecutive_num.length
      puts "-----------------"
      print "\e[36m"
      puts "#{@consecutive_num.join('と')}が揃いました！\n#{@add_score}点獲得!"
      print "\e[0m"
      ask_stake
    # 揃っている数字がなかったら
    else
      puts "-----------------"
      print "\e[31m"
      puts "残念"
      print "\e[0m"
      # 残り金額がなかったらGAME OVER
      if @remaining_amount <= 0
        print "\e[31m"
        puts "GAME OVER"
        print "\e[0m"
        return
      end
      ask_stake
    end
  end
end

game = Game.new(100)
