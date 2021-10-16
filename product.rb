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
    def drink_data_delete(number)
    end
  end