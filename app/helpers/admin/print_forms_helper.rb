module Admin::PrintFormsHelper
  def can_be_accessed_by_form_column(record, name)
    select_tag("#{name}[]",
      options_for_select(User::USER_TYPES, record.can_be_accessed_by), {:multiple=>true, :size=>4})
  end

  def can_be_accessed_by_column(record)
    User::USER_TYPES.select { |el| record.can_be_accessed_by.include?(el.last) }.map(&:first).join(', ')
  end

  def printable_type_column(record)
    PrintForm::PRINTABLE_TYPES.detect { |el| el.last == record.printable_type }.first
  end
end
