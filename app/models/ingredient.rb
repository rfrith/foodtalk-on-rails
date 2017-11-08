class Ingredient < ApplicationRecord

  UNITS_OF_MEASURE = {
      :bn  => :bunch,
      :cn  => :can,
      :ct  => :carton,
      :cg  => :centigram,
      :cl  => :centiliter,
      :clv  => :clove,
      :c  => :cup,
      :ds  => :dash,
      :dl  => :deciliter,
      :dr  => :drop,
      :floz  => :fluid_ounce,
      :gal  => :gallon,
      :g  => :gram,
      :kg  => :kilogram,
      :l  => :liter,
      :lf  => :loaf,
      :mg  => :milligram,
      :ml  => :milliliter,
      :oz  => :ounce,
      :pk  => :package,
      :pn  => :pinch,
      :pt  => :pint,
      :lb  => :pound,
      :q  => :quart,
      :sli  => :slice,
      :T  => :tablespoon,
      :t  => :teaspoon,
      :u  => :unit,
      :unknown  => :unknown,
      :w => :whole
  }

  belongs_to :recipe

  #TODO: add validation

end
