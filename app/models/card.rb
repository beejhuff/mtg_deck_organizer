class Card < ActiveRecord::Base
  has_many :deck_cards
  has_many :decks, through: :deck_cards
  validates :name, presence: true
  validates :cost, presence: true,
    format: {with: /\A[WBRUG0-9]+\z/, message: "please enter white as W, blue as U, red as R, green as G, black as B, and colorless as numbers"}
  validates :card_type, presence: true
end