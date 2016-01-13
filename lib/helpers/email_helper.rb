# encoding UTF-8

require 'mail'

module Carmin
	class EmailHelper

		DELIMITER = "-"

		def self.send_email(config_hash, list_txt_collection)
			Mail.defaults do
 				delivery_method :smtp, address: config_hash['mail_smtp_server'], port: config_hash['mail_smtp_port'], user_name: config_hash['mail_smtp_user'], password: config_hash['mail_smtp_password'], openssl_verify_mode: "none"
			end

			recipients = config_hash['emails'][create_recipient_name(list_txt_collection.keys.first)]
			subject = create_subject()

			first_part = %Q(Witaj!

To jest wiadomość z systemu zbierania informacji CARMIN. Została wygenerowana automatycznie, nie odpowiadaj na nią. Miłej lektury!

#{delimiter}

#{list_txt_collection.values.join("\n")}

To wszystko na dziś. Pozdrawiamy i przypominamy, że tylko RAZEM damy radę!

Więcej informacji: #carmin)

			mail = Mail.new do
			  from    'carmin@mgpm.pl'
			  bcc      recipients
			  subject subject
			  body    first_part
			end

			mail.deliver
		end

		def self.create_card_txt(card)
			media = get_label_value(card, "orange")
			language = get_label_value(card, "red")
			tags = get_labels_collection(card, "purple")
%Q(
# #{card.name}
--#{([DELIMITER] * card.name.length).join()}
#{card.attachments.select{ |att| att.bytes == 0 }.first.url}
  Żródło: #{card.desc['source']}
  Media: #{media} [#{language}]
  Tagi: #{tags.join(" ")}
)
		end

		def self.get_label_value(card, color)
			card.labels.select{ |label| label.color == color }.first.name
		end

		def self.delimiter
			([DELIMITER] * 30).join()
		end

		private

		def self.get_labels_collection(card, color)
			card.labels.select{ |label| label.color == color }.map{ |label| "[#{label.name}]" }
		end

		def self.create_subject()
			"Informacje CARMIN z #{DateTime.now.strftime("%F %H:%M")}"
		end

		def self.create_message(recipient, group_name, message)
			"From: CARMIN <carmin@mgpm.pl>\nTo: #{recipient}\nSubject: CARMIN message for list: #{group_name}\n\n#{message}"
		end

		def self.create_recipient_name(group_name)
			group_name.downcase.gsub(" ", "").gsub(/[^a-zA-Z0-9\-]/,"")
		end
	end
end