# frozen_string_literal: true

class AccountSerializer
  include FastJsonapi::ObjectSerializer
  attributes :description, :balance
end
