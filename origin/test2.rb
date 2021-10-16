# irb
# load './jihanki.rb'
# vm = VendingMachine.new(1)
# 作成した自動販売機に100円を入れる
# vm.slot_money (100)
# 作成した自動販売機に入れたお金がいくらかを確認する（表示する）
# vm.current_slot_money
# 作成した自動販売機に入れたお金を返してもらう
# vm.return_money
#------------------------------------------------------------------------------------------------------------------------------
module Display
  #コンソールへの表示
  def start
    #初期画面
    loop{
        self.cs_list
        #デフォルトで情報を表示
        puts "\nいらっしゃいませ！"
        puts "使用方法"
        puts "お金の投入：任意の金額を半角数字で入力しエンターキー　例 100円を投入するときは100"
        puts "商品購入:商品名を入力しエンターキー"
        puts "投入金の返金：返金　と入力しエンターキー"
        puts "買い物を終了するときは end と入力しエンターキー"

        user_input = gets.chomp

        case user_input
          #入力情報により条件分岐
        when "10", "50", "100", "500", "1000"
          #お金の投入
          user_input = user_input.to_i
          self.slot_money(user_input)
        when "返金"
          #返金
          puts "\nお釣り#{@slot_money}円"
          self.return_money
        when "end"
          #ループから抜ける
          puts "\nご利用ありがとうございました"
          break
        when "mg mode"
          #管理モードへの移行
          self.mg_mode
        else
          #商品の購入モードへ移行
          user_input = user_input.to_sym
          if @products.keys.include?(user_input)
            self.buy(user_input)
          else
            puts "有効な入力情報では有りません"
          end
        end
      }
  end

  def cs_list
    #購入者用の情報表示
    #3-1 購入可能な商品一覧の取得
    #4-2 購入可能な商品一覧の取得
    i = 1
    puts "\n\n------------------------------------------------------------------------"
    puts "---------------------------自動販売機-----------------------------------"
    puts "------------------------------------------------------------------------"
    @products.each{|product_name, price_stock|
      if price_stock[:stock] == 0
        #もし在庫がなかったら
        puts "\n#{product_name}　値段:#{price_stock[:price]}円 在庫:#{price_stock[:stock]} 在庫切れ"
      elsif @slot_money < price_stock[:price]
        #もし投入金額が足りなかったら
        puts "\n#{product_name}　値段:#{price_stock[:price]}円 在庫:#{price_stock[:stock]} お金が足りません"
      elsif @slot_money >= price_stock[:price] && price_stock[:stock] > 0
        #もし投入金額が足りており、在庫もあったら
        puts "\n#{product_name}　値段:#{price_stock[:price]}円 在庫:#{price_stock[:stock]} 購入可能"
      end
      i += 1
    }
    puts "\n------------------------------------------------------------------------"
    puts "投入残金額#{@slot_money}円"
    if @my_orders.length == 0
      puts "購入品：なし"
    else
      puts "購入品：#{@my_orders.join(',')}"
    end
  end


  def mg_mode
    #管理モード
    loop {
      self.mg_list
      puts "\n管理モード中…"
      puts "任意の数字を入力してエンターキーを押して下さい"
      puts "すでにある商品補充：1"
      puts "すでにある商品をへらす：2"
      puts "すでにある商品を削除：3"
      puts "新規商品の追加：4"
      puts "売上金の回収：5"
      puts "管理モードの終了：6"

      user_input = gets.chomp.to_i

      case user_input
        #入力情報により条件分岐
      when 1
        #すでにある商品の追加モードへ移行
        self.addition_products
      when 2
        #すでにある商品をへらすモードへ移行
        self.reduce_products
      when 3
        #すでにある商品を削除するモードへ移行
        self.delete_products
      when 4
        #新規商品の追加モードへ移行
        self.new_pro_mg
      when 5
        #売上金の引き出し
        puts "\n売上金額#{@sales_amount}円を回収しました"
        self.withdrawals
      when 6
        #初期画面へ移行
        break
      end
    }
  end

  def mg_list
    #管理者用の情報表示
    #2-2 商品一覧の取得
    #3-4 売上金額取得
    puts "\n\n----------------------------------------------------------------------"
    puts "------------------------------管理モード------------------------------"
    puts "----------------------------------------------------------------------"
    @products.each{|product_name, price_stock|
      puts "\n#{product_name}　値段:#{price_stock[:price]}円 在庫:#{price_stock[:stock]}個"
    }
    puts "\n----------------------------------------------------------------------"
    puts "売上金額#{@sales_amount}円"
  end
end


#------------------------------------------------------------------------------------------------------------------------------
module Process
  #メソッドのモジュール
  MONEY = [10, 50, 100, 500, 1000].freeze

  def current_slot_money
    #0-3 投入金額総計を取得できる
    @slot_money
  end

  def slot_money(money)
    #0-1 お金の１つずつ投入できる
    #0-2 複数回投入できる
    #1-1 想定外のもの
    return false unless MONEY.include?(money)
    @slot_money += money
  end

  def return_money
    #0-4 払い戻し及び総計金額のリセット
    @slot_money = 0
  end

  def withdrawals
    #売上金額の回収
    @sales_amount = 0
  end

  def new_products(name, price, stock)
    #新規商品追加
    pro = Product.new
    @products[name] = pro.new_p(price, stock)
  end

  def add_products(name, new_stock)
    #既存商品追加
    pro = Product.new
    stock = @products[name][:stock]
    @products[name][:stock] = pro.add_p(stock, new_stock)
  end

  def red_products(name, reduce)
    #既存商品を減らす
    pro = Product.new
    stock = @products[name][:stock]
    @products[name][:stock] = pro.red_p(stock, reduce)
  end

  def del_products(name)
    #既存商品の削除
    @products.delete(name)
  end

  def addition_products
    #既存商品の追加
    puts "追加する既存の商品名を入力して下さい"
    product_name = gets.chomp.to_sym
    if @products.keys.include?(product_name)
      puts "#{product_name}の在庫数：#{@products[product_name][:stock]}個"
      puts "追加する個数を半角数字で入力して下さい"
      addition_stock = gets.chomp.to_i
      self.add_products(product_name, addition_stock)
      puts "\n#{product_name}を#{addition_stock}個追加しました"
      puts "#{product_name}の在庫数：#{@products[product_name][:stock]}個"
    else
      puts "入力された商品がありません"
    end
  end

  def reduce_products
    #既存商品をへらす
    puts "在庫を減らす既存の商品名を入力して下さい"
    product_name = gets.chomp.to_sym
    if @products.keys.include?(product_name)
      puts "#{product_name}の在庫数：#{@products[product_name][:stock]}個"
      puts "減らす個数を半角数字で入力して下さい"
      reduce_stock = gets.chomp.to_i
      self.red_products(product_name, reduce_stock)
      puts "\n#{product_name}を#{reduce_stock}個減らしました"
      puts "#{product_name}の在庫数：#{@products[product_name][:stock]}個"
    else
      puts "入力された商品がありません"
    end
  end

  def delete_products
    #既存商品を削除する
    puts "削除する既存の商品名を入力して下さい"
    product_name = gets.chomp.to_sym
    if @products.keys.include?(product_name)
      self.del_products(product_name)
      puts "\n#{product_name}を削除しました"
    else
      puts "入力された商品がありません"
    end
  end

  def new_pro_mg
    puts "新規に追加する商品名を入力して下さい"
    product_name = gets.chomp.to_sym
    puts "値段を半角数字で入力して下さい"
    product_price = gets.chomp.to_i
    puts "追加する個数を半角数字で入力して下さい"
    product_stock = gets.chomp.to_i
    self.new_products(product_name, product_price, product_stock)
    puts "\n商品追加完了"
    puts "「#{product_name}」値段:#{product_price}円 在庫:#{product_stock}個"
  end

  def buy(product_name)
    #3-2 ジュースの購入及び在庫数の変動
    #3-3 金額が足りない場合何もしない
    #5-1 釣り銭の出力
    product = @products[product_name]
    if product[:stock] == 0
      puts "在庫切れ"
    elsif @slot_money < product[:price]
      puts "お金が足りません"
      puts "\n投入残金額#{@slot_money}"
    elsif @slot_money >= product[:price] && product[:stock] > 0
      self.red_products(product_name, 1)
      @slot_money = @slot_money - @products[product_name][:price]
      @sales_amount = @products[product_name][:price]
      @my_orders << product_name.to_s
      puts "\n#{product_name}購入完了"
    end
  end
end
#------------------------------------------------------------------------------------------------------------------------------
class Product
  attr_reader :drink_data

  def initialize
    @drink_data = {}
    #{number: { name: name, price: price }…..}
    @drink_data_register(001, "コーラ", 120)
  end

  def drink_data_register(number, name, price)
    
  end

  def change_name(number, name)

  end

  def change_price(number, price)

  end

  # def drink_data_delete(number)

  # end


  
  
end
#------------------------------------------------------------------------------------------------------------------------------
class VendingMachine

  def initialize
    @product = Product.new
    @insert = Insert.new
    mode_selection
  end

  def mode_selection
    loop { 
      user_input = gets.chomp
      case user_input
      when 1
        sales_mode


      when 2
        admin_mode

        
      when 3
        product_db_mode


      when 4
        break

      end


     }


  end
  
  def sales_mode
    loop {

      information_display
      user_input = gets.chomp
      case user_input
      when 1
        deposit(user_input)
 
      when 2
        return_money
 
         
      when 3
        push_button(user_input)
        
      when 4
        break
 
 
 
      end
 
 
      }

  end


  def admin_mode
    loop { 
      user_input = gets.chomp
      case user_input
        # 自販機への商品の割当
        # 商品の個数の補充
        # 商品の個数をへらす
        # 商品の削除
        # 売上金の回収
  
      when 1
        drink_allocation
 
 
      when 2
         drink_increase
         
      when 3



      when 4


      when 5
 

      when 6
 
 
       end
 
 
      }

  end

  def product_db_mode
    loop { 
      user_input = gets.chomp
      case user_input
        #商品の登録
        #商品名の変更
        #値段の変更
        #商品の登録削除
        #ブレイク
      when 1
 
 
      when 2
 
         
      when 3


      when 4


      when 5
 
 
 
      end
 
 
      }

  end

  def information_display
  #putsで情報出力
    i = @product.drink_data
    j = @insert.slot_money
    @stock.drink_list_creation(i, j)
  end

  def deposit(user_input)
  #投入されたお金が使用できるか判断
    if @insert.money_judgement(user_input)
  #使えればInsertクラスのメソッドに引数を渡す
      @insert.money_addition(user_input)
    else 
  #使えなかったら使えないメッセージを出力
    end

  end

  def return_money
    @insert.money_decrease(@insert.money_amount)
    

  end

  def push_button(user_input)
    

  end
  
end
#------------------------------------------------------------------------------------------------------------------------------
class Stock
  def initialize
    #配列内配列
    @drink_stock = { A: [], B: [], C: [], D: [], E: [], F: [] }
    #[[001, 5],[002, 5]]
    #{A: [001, 5], B: [002, 8] }
    drink_addition("A", 001, 5)
  end

  def drink_addition(stock_position, drink_number, count)
    
  end

  def drink_increase(stock_position, count)
    
  end

  def drink_decrease(stock_position, count)

  end


  def drink_deleate(stock_position)

  end

  def drink_buyable_judgement(stock_position, slot_money)
  #期待する戻り値　1or2or3or4
  #1:購入可能
  #2:お金不足
  #3:品切れ
  #4:商品が存在しない(未設定)
  end

  def drink_list_creation(drink_data, slot_money)
    
  end


end
#------------------------------------------------------------------------------------------------------------------------------
class Insert
  attr_reader :slot_money

  def initialize
    @slot_money = 0

  end

  def money_judgement(value)

  end

  def money_increase(value)

  end

  def money_decrease(value)

  end

  def money_amount

  end

end
#------------------------------------------------------------------------------------------------------------------------------
class MoneyManagement

end
#------------------------------------------------------------------------------------------------------------------------------
class SalesManagement
  attr_reader :proceeds

  def initialize
    @proceeds = 0

  end

  def proceeds_increase(value)

  end

  def proceeds_decrease(value)

  end


end





