# frozen_string_literal: true

class Transfer < ApplicationRecord
  belongs_to :source_account, class_name: 'Account',
                              foreign_key: :source_account_id
  belongs_to :destination_account, class_name: 'Account',
                                   foreign_key: :destination_account_id

  validates :destination_account_id, :source_account_id, :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 1 }
  validates :destination_account_id,
            exclusion: { in: ->(transfer) { [transfer.source_account_id] } }
  with_options if: :valid_until_now? do
    validate :source_account_balance
  end

  def source_account_balance
    negative_balance = (source_account.calculate_balance - amount).negative?
    errors.add(:transfer, 'Insufficient funds') if negative_balance
  end
end
