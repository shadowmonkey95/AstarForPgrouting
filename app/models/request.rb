class Request < ApplicationRecord
  belongs_to :shop, optional: true
end
