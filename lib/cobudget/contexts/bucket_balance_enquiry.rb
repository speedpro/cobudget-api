require 'playhouse/context'
require 'cobudget/entities/bucket'
require 'cobudget/roles/budget_participant'
require 'cobudget/roles/entry_collection'

module Cobudget
  class BucketBalanceEnquiry < Playhouse::Context
    actor :bucket, role: EntryCollection, repository: Bucket

    def perform
      Money.new(bucket.balance)
    end
  end
end