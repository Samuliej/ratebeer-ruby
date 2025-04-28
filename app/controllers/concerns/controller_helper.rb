module ControllerHelper
  def top(record, number)
    record.all.sort_by(&:average_rating).reverse.take(number)
  end
end
