module Accela
  class Record < Model
    has_one :type, :status, :renewal_info
    has_many :addresses, :contacts, :parcels, :owners
  end
end
