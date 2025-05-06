module Top
  def top(amount)
    includes(:ratings).all.sort_by(&:average_rating).reverse.take(amount)
  end
end
