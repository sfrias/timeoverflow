module Persister
  class PostPersister
    attr_accessor :post

    def initialize(post)
      @post = post
    end

    def save
      ::ActiveRecord::Base.transaction do
        post.save!
        create_save_event!
        post
      end
    rescue ActiveRecord::RecordInvalid => _exception
      false
    end

    def update_attributes(params)
      ::ActiveRecord::Base.transaction do
        post.update_attributes!(params)
        create_update_event!
        post
      end
    rescue ActiveRecord::RecordInvalid => _exception
      false
    end

    private

    def create_save_event!
      ::Event.create! action: :created, post: post
    end

    def create_update_event!
      ::Event.create! action: :updated, post: post
    end
  end
end