module RatingAverage
  extend ActiveSupport::Concern
    def calculate_average
      all_ratings = @ratings.map { |rating| rating.score }
      all_score_sum = all_ratings.inject(:+)

      (all_score_sum / (@ratings.count.to_f)).truncate(1)
    end
end
