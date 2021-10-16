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