module ApplicationHelper

  def format_date(datetime)
    datetime&.strftime('%b %d, %Y')
  end

  def format_time(datetime)
    datetime&.strftime('%I %P')
  end

  def format_date_range(datetime_1, datetime_2)
    if datetime_1.to_date == datetime_2.to_date
      format_date(datetime_1)
    elsif datetime_1.year != datetime_2.year
      datetime_1&.strftime('%b %d, %Y') + ' - ' + datetime_2&.strftime('%b %d, %Y')
    else
      datetime_1&.strftime('%b %d') + ' - ' +
      format_date(datetime_2)
    end
  end
end
