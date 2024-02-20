# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require 'dotenv'
require 'hudu'
require 'minitest/autorun'
require 'minitest/spec'

Dotenv.load
