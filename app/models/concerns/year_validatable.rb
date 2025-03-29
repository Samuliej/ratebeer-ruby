module YearValidatable
  extend ActiveSupport::Concern

  included do
    validate :validate_year
  end

  class_methods do
    def year_attribute(attr_name)
      @year_attribute = attr_name
    end

    def get_year_attribute
      @year_attribute || :year
    end
  end

  private

  def validate_year
    year_value = send(self.class.get_year_attribute)
    return if year_value.blank?

    if year_value < self.class::MINIMUM_YEAR
      errors.add(self.class.get_year_attribute, "can't be smaller than #{self.class::MINIMUM_YEAR}")
    end

    return unless year_value > Time.now.year

    errors.add(self.class.get_year_attribute, "can't be greater than current year")
  end
end
