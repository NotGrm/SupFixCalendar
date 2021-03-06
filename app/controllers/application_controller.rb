class ApplicationController < ActionController::Base
	protect_from_forgery
	before_filter :set_locale

	def set_locale
		logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
		supported_locales = ["en", "fr"]
		extracted_locale = extract_locale_from_accept_language_header
		I18n.locale = supported_locales.index(extracted_locale)? extracted_locale : I18n.default_locale
		# I18n.locale = extract_locale_from_accept_language_header || I18n.default_locale
		logger.debug "* Locale set to '#{I18n.locale}'"
	end

	private
	def extract_locale_from_accept_language_header
		request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
	end
end
