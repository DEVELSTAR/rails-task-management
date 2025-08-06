class CatFact < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "fact", "id", "id_value", "source", "updated_at"]
  end
end
