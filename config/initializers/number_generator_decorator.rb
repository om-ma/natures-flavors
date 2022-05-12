Spree::Core::NumberGenerator.class_eval do

  # Override to support sequential order numbers
  def generate_permalink(host)
    length = @length
    
    loop do
      candidate = (host.name == "Spree::Order" ? new_order_candidate() : new_candidate(length))
      return candidate unless host.exists?(number: candidate)
      
      # If over half of all possible options are taken add another digit.
      length += 1 if host.count > Rational(Spree::Core::NumberGenerator::BASE**length, 2)
    end
  end
  
  def new_order_candidate()
    if Spree::Order.count == 0
      last_number = 100000000
    else
      last_number = Spree::Order.order(Arel.sql('length(number) desc, number desc')).pluck(:number).first[1..-1].to_i
    end

    return "#{@prefix}#{last_number+1}"
  end
end
