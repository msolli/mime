class LocationValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    return if array?(value) && value[0].blank? && value[1].blank?
    record.errors[attribute] << I18n.t('errors.messages.invalid') unless array?(value) && numeric?(value[0]) && numeric?(value[1])
  end

  private
  def array?(value)
    value.is_a?(Array)
  end

  def numeric?(value)
    value.is_a?(Numeric)
  end
end
