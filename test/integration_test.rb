# frozen_string_literal: true

require 'test_helper'

GITHUB_REPO_NAME = 'bridgetown-automation-stimulus'
BRANCH = `git branch --show-current`.chomp.freeze || 'master'

class IntegrationTest < Minitest::Test
  def setup
    Rake.rm_rf(TEST_APP)
    Rake.mkdir_p(TEST_APP)
  end

  def read_test_file(filename)
    File.read(File.join(TEST_APP, filename))
  end

  def run_assertions
    index_js = read_test_file('frontend/javascript/index.js')

    # Stimulus imported
    assert_match(/import { Application } from "stimulus"/, index_js)
    assert_match(%r!import { definitionsFromContext } from "stimulus/webpack-helpers"!, index_js)

    # Make sure package.json contains stimulus
    package_json = read_test_file('package.json')

    assert_match(/const application = Application.start()/, index_js)
    assert_match(%r{const context = require.context\("./controllers", true, /\.js\$/\)}, index_js)
    assert_match(/application.load\(definitionsFromContext\(context\)\)/, index_js)

    # Check the directory was created
    controller_dir = File.join(TEST_APP, 'frontend', 'javascript', 'controllers')
    assert Dir.exist?(File.join(controller_dir))
    assert File.exist?(File.join(controller_dir, 'example_controller.js'))
  end

  def test_it_works_with_local_automation
    Rake.cd TEST_APP

    Rake.sh('bundle exec bridgetown new . --force --apply="../bridgetown.automation.rb"')

    run_assertions
  end

  # Have to push to github first, and wait for github to update
  def test_it_works_with_remote_automation
    Rake.cd TEST_APP

    github_url = 'https://github.com'
    user_and_reponame = "ParamagicDev/#{GITHUB_REPO_NAME}/tree/#{BRANCH}"

    file = 'bridgetown.automation.rb'

    url = "#{github_url}/#{user_and_reponame}/#{file}"

    Rake.sh('bundle exec bridgetown new . --force ')
    Rake.sh("bridgetown apply #{url}")

    run_assertions
  end
end
