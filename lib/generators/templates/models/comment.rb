class Comment
  include Mongoid::Document
  include Mongoid_Commentable::Comment
  include Rake::DSL
  
  attr_accessible :text, :author
  field :text, :type => String
  field :author, :type => String
end
