module RatingAverage
  extend ActiveSupport::Concern
  def calculate_average
    all_ratings = @ratings.map(&:score)
    all_score_sum = all_ratings.sum

    (all_score_sum / @ratings.count.to_f).truncate(1)
  end
end
