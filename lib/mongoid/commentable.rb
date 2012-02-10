module Mongoid::Commentable
  extend ActiveSupport::Concern
  
  included do |base|
    base.embeds_many :comments, :as => :commentable
    base.index [['comments', Mongo::ASCENDING]]
  end
    
  module ClassMethods
    def commentable?
      true
    end
  end
    
  def create_comment!(params)
    comment = comments.create!(params)
    comment.path = comment.parent ? comments.find(comment.parent).path + '.' + comment.id.to_s : "root."+comment.id.to_s
    comment
  end

  def comments_list(sort=:asc, page=1, limit=10)
    if Comment.respond_to?(sort)
      comments.send(:order_by, :created_at, sort).limit(limit).skip( (page - 1)*limit )
    else
      raise ArgumentError, "Wrong argument!"
    end
  end

  def branch_for(comment_id)
    comments.select{|i| i.path =~ Regexp.new('^' + comments.find(comment_id).path)}
  end

end

