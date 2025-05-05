module RatingAverage
  extend ActiveSupport::Concern
  include ApplicationHelper
  def calculate_average
    return 0 if @ratings.empty?

    all_ratings = @ratings.map(&:score)
    all_score_sum = all_ratings.sum
    rating_count = all_ratings.size

    round((all_score_sum / rating_count.to_f))
  end

  def best_rated(record)
    average_ratings = case record
                      when :beer
                        @ratings.map{ |r| { beer: r.beer, average_rating: r.beer.average_rating } }
                      when :brewery
                        @ratings.map{ |r| { brewery: r.beer.brewery, average_rating: r.brewery.average_rating } }
                      else
                        []
                      end

    average_ratings.sort_by{ |a| a[:average_rating] }.reverse.take(3)
  end
end
