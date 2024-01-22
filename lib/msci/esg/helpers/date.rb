# frozen_string_literal: true

require "date"

module Msci
  module Esg
    # this class will be work with DateTime
    class Date
      SEC_BY_DAY = 86_400
      SEC_BY_HOUR = 3_600
      SEC_BY_MIN = 60

      class << self
        def get_expired_date(expires_in)
          date_now = DateTime.now
          days = Msci::Esg::Date.get_days(expires_in)
          hours = Msci::Esg::Date.get_hours(expires_in, days)
          mins = Msci::Esg::Date.get_minutes(expires_in, days, hours)
          sec = Msci::Esg::Date.get_seconds(expires_in, days, hours, mins)

          DateTime.new(
            date_now.year, date_now.month, (date_now.day + days),
            (date_now.hour + hours), (date_now.min + mins), (date_now.sec + sec),
            date_now.offset
          )
        end

        def get_days(seconds)
          (seconds / SEC_BY_DAY).round
        end

        def get_hours(seconds, days = 0)
          ((seconds - (days * SEC_BY_DAY)) / SEC_BY_HOUR).round
        end

        def get_minutes(seconds, days = 0, hours = 0)
          ((seconds - (days * SEC_BY_DAY) - (hours * SEC_BY_HOUR)) / SEC_BY_MIN).round
        end

        def get_seconds(seconds, days = 0, hours = 0, mins = 0)
          (seconds - (days * SEC_BY_DAY) - (hours * SEC_BY_HOUR) - (mins * SEC_BY_MIN)).round
        end
      end
    end
  end
end
