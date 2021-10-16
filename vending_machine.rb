require './product'
require './vending_machine_parts/insert'
require './vending_machine_parts/stock'
require './vending_machine_parts/salse_managemant'
require './vending_machine_parts/mony_managemant'

class VendingMachine

    def initialize
      @product = Product.new
      @insert = Insert.new
      @stock = Stock.new
      @salse_managemant = SalseManagemant.new
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