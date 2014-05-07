class Book < ActiveRecord::Base
  has_and_belongs_to_many :authors

  validates :isbn,
    presence: true,
    uniqueness: true,
    length: { is: 17 },
    isbn: true
  validates :title,
    presence: true,
    length: { minimum: 1, maximum: 100 }
  validates :price,
    numericality: { only_integer: true, less_than: 10000 }
  validates :publish,
    inclusion:{ in: ['技術評論社', '翔泳社', '秀和システム', '日経BP社', 'ソシム'] }
end
