class AlphabeticConstraint
  def self.matches?(request)
    request.path_parameters[:letter] && request.path_parameters[:letter].size == 1
  end
end
