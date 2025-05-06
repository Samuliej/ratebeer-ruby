module TopHelper
  # Kun otettiin ratings mukaan niin SQL-kyselyjen määrä
  # tippui tuhansista alle kymmeneen
  def top(record, number)
    record.includes(:ratings).all.sort_by(&:average_rating).reverse.take(number)
  end
end
