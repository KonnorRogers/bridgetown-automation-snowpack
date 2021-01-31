# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
require 'rake'

ROOT_DIR = File.expand_path('..', __dir__)

TEST_DIR = File.expand_path(__dir__)
TEST_APP = File.expand_path('test_app')
TEST_GEMFILE = File.join(TEST_APP, 'Gemfile')

reporter_options = { color: true, slow_count: 5}
Minitest::Reporters.use!(
  [
    Minitest::Reporters::DefaultReporter.new(reporter_options),
  ]
)
