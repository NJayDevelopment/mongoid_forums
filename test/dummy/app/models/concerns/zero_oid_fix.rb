module ZeroOidFix
  extend ActiveSupport::Concern

  module ClassMethods
    def serialize_from_session(key, salt)
      record = to_adapter.get((key[0]["$oid"] rescue nil))
      record if record && record.authenticatable_salt == salt
    end
  end
end
