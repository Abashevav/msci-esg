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
          vars = _prepare_all_variables(expires_in)

          _create_expired_date(date_now, vars)
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

        def _prepare_all_variables(seconds)
          days = Msci::Esg::Date.get_days(seconds)
          hours = Msci::Esg::Date.get_hours(seconds, days)
          mins = Msci::Esg::Date.get_minutes(seconds, days, hours)
          sec = Msci::Esg::Date.get_seconds(seconds, days, hours, mins)

          { days: days, hours: hours, mins: mins, sec: sec }
        end

        def _create_expired_date(date_now, vars)
          DateTime.new(
            date_now.year, date_now.month,
            date_now.day + vars[:days],
            date_now.hour + vars[:hours],
            date_now.min + vars[:mins],
            date_now.sec + vars[:sec],
            date_now.offset
          )
        end
      end
    end
  end
end
