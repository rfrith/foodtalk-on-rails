class OnlineLearningHistory < ActivityHistory

  validates_presence_of :name, :user

  scope :better_u, -> { where("name like '%better_u%'") }
  scope :food_etalk, -> { where("name like '%food_etalk%'") }
  scope :find_by_module_id, ->(id = nil) { where("name like '%#{id}%'") }

end