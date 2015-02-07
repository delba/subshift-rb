require 'time'

class String
  TIME = /\d{2}:\d{2}:\d{2},\d{3}/

  def shift_times(delay)
    gsub(TIME) do |time|
      Subshift::Time.parse(time) + delay
    end
  end

  def timeline?
    /-->/ === self
  end
end
