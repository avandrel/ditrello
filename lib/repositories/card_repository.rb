require 'mongo'

module Carmin
	class CardRepository
		def initialize(mongo_helper)
			@mongo_helper = mongo_helper
		end

		def card_in_repo?(url)
			puts url
            @mongo_helper.cards_collection.find({:source_url => "#{url}"}).first() != nil
        end

		def add_card(card)
			attributes = card.attributes
			attributes[:source_url] = card.attachments.select{ |att| att.bytes == 0 }.first.url
        	@mongo_helper.cards_collection.insert_one(attributes)
        end

        def update_card(card)
        	attributes = card.attributes
			attributes[:source_url] = card.attachments.select{ |att| att.bytes == 0 }.first.url
        	@mongo_helper.cards_collection.update_one({:source_url => "#{card.url}"}, attributes)
        end
	end
end