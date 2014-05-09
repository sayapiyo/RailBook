class TimeConstraint
  def matches?(request)
    current = Time.now
    current.hour >= 9 && current.hour < 10
  end
end
