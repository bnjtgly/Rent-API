module UserProfileDetails
  extend ActiveSupport::Concern
  def get_profile_diff(old, new)
    old.diff(new)
  end
end

class Hash
  def diff(other)
    result = {}
    self.keys.each do |key|
      if self[key] != other[key]
        result[key] = other[key]
      end
    end
    result
  end
end
