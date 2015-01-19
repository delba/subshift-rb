require 'time'

class String
  TIME = /\d{2}:\d{2}:\d{2},\d{3}/

  def shift_times(delay)
    gsub(TIME) do |time|
      new_time = Time.parse(time) + delay
      new_time.strftime '%H:%M:%S,%3N'
    end
  end

  def timeline?
    /-->/ === self
  end
end
