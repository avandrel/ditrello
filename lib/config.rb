module DiTrello
	class Config
		def self.get_config_hash
			config_hash = {}
			if ENV['RACK_ENV'] != 'production'
				config_hash = YAML.load(File.read("config.yml"))
			else
				config_hash = self.get_config_from_env
			end
			config_hash
		end

		private

		def self.get_config_from_env
			config_hash = {}

			config_hash['trello_developer_public_key'] = ENV['TRELLO_DPK']
			config_hash['trello_member_token'] = ENV['TRELLO_MT']
			config_hash['trello_username'] = ENV['TRELLO_U']
			config_hash['trello_board_id'] = ENV['TRELLO_BI']
			config_hash['trello_board_url'] = ENV['TRELLO_BU']

			config_hash['discourse_url'] = ENV['DISCOURSE_U']
			config_hash['discourse_api_key'] = ENV['DISCOURSE_AK']
			config_hash['discourse_api_username'] = ENV['DISCOURSE_AU']

			config_hash['slack_wywiad_incoming_hooks'] = ENV['SLACK_WIH']
			config_hash['slack_wywiad_outgoing_token'] = ENV['SLACK_WOT']
			
			config_hash
		end
	end
end

