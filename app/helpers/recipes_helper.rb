module RecipesHelper

  def to_mixed_number(amount)
    amount_as_integer = amount.to_i
    if (amount_as_integer != amount.to_f) && (amount_as_integer > 0)
    fraction = amount - amount_as_integer
    "#{amount_as_integer} #{fraction}"
    else
      amount.to_s
    end
  end

end