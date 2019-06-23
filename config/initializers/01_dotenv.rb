# frozen_string_literal: true

unless PostCodes.production?
	require "dotenv"
	Dotenv.load
end
