# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'yaml'

DISCLAIMER = <<~CAUTION
  WARNING:
    This automation will perform many dangerous operations to your project.
    This includes gsubbing of your `src/_components/head.liquid`,
    changing the output of `bridgetown build`, and many other changes. Please read
    the readme available here: https://github.com/ParamagicDev/bridgetown-automation-snowpack
    and checkout the source code here: https://github.com/ParamagicDev/bridgetown-automation-snowpack
    before continuing. Also commit your changes before running this so you can easily
    revert back.

    Would you like to continue? (Y / N)
CAUTION

def main
  no = no?(DISCLAIMER, :red)

  if no
    say "Aborting...\n", :red
    return
  end

  @package_json = JSON.parse(File.read("package.json"))

  say 'Removing Webpack', :blue
  FileUtils.rm 'webpack.config.js' if File.exist?("webpack.config.js")

  say 'Removing start.js and sync.js', :blue
  %w(start.js sync.js).each { |file| FileUtils.rm(file) if File.exist?(file) }

  say 'Removing unneeded npm packages', :blue
  remove_npm_packages

  say 'Adding Snowpack configs', :green
  add_snowpack_files

  say 'Adding Snowpack scripts', :green
  add_snowpack_scripts

  File.write("package.json", JSON.pretty_generate(@package_json))

  say "Rewriting frontend/javascript/index.js"
  rewrite_index_js

  say "Rewriting webpack references in src/_components/head.liquid"
  rewrite_webpack_references

  say "Updating your bridgetown config..."
  update_bridgetown_config

  say 'Installing Snowpack', :green
  install_snowpack

  say "Installation successful! 🎉", :green

  say "\n\nRun `yarn start` to start up your dev server and go to `localhost:4000`"
end

def install_snowpack
  run('yarn add snowpack @snowpack/plugin-run-script @snowpack/plugin-sass')
end

def rewrite_index_js
  index_js = <<~JAVASCRIPT
    console.info("Bridgetown is loaded!")
  JAVASCRIPT

  create_file("frontend/javascript/index.js", index_js)
end

def add_snowpack_files
  snowpack_config_js = <<~JAVASCRIPT
    // Snowpack Configuration File
    // See all supported options: https://www.snowpack.dev/#configuration

    /** @type {import("snowpack").SnowpackUserConfig } */
    module.exports = {
      mount: {
        frontend: "/dist",
        ".bridgetown": { url: "/", static: true },
        output: { url: "/", static: true, resolve: false },
      },
      plugins: [
        [
          "@snowpack/plugin-run-script",
          {
            name: "bridgetown",
            cmd: "bundle exec bridgetown build",
            watch: "$1 --watch --quiet",
          },
        ],
        ["@snowpack/plugin-sass", {compilerOptions: { style: "compressed" }}],
      ],
      devOptions: {
        port: 4000,
        hmrDelay: 1000,
        open: "none",
        output: "stream"
      },
      buildOptions: {
        metaUrlPath: "dist/javascript",
        out: "output"
      },
      optimize: {
        entrypoints: ["dist/javascript/index.js"],
        preload: false,
        bundle: true,
        splitting: false,
        treeshake: true,
        minify: true,
        manifest: true,
        target: "es2018",
      },
    }
  JAVASCRIPT

  create_file("snowpack.config.js", snowpack_config_js)
end

def remove_npm_packages
  npm_packages = %w[
    @babel/core
    @babel/plugin-proposal-class-properties
    @babel/plugin-proposal-decorators
    @babel/plugin-transform-runtime
    @babel/preset-env
    babel-loader
    browser-sync
    concurrently
    css-loader
    file-loader
    mini-css-extract-plugin
    node-sass
    sass-loader
    webpack
    webpack-cli
    webpack-manifest-plugin
  ]

  npm_packages.each do |pkg|
    say "Removing: #{pkg}..."
    @package_json["devDependencies"].delete(pkg)
  end
end

def add_snowpack_scripts
  scripts = {
    "build:bridgetown" => "bin/bridgetown build",
    "build" => "NODE_ENV=production BRIDGETOWN_ENV=production snowpack build",
    "clean:bridgetown" => "bundle exec bridgetown clean",
    "restart" => "yarn clean:bridgetown && yarn start --reload",
    "start" => "NODE_ENV=development BRIDGETOWN_ENV=development snowpack dev",
    "deploy" => "yarn clean:bridgetown && yarn build"
  }
  @package_json["scripts"].merge!(scripts)
end

def rewrite_webpack_references
  head_liquid = "src/_components/head.liquid"
  gsub_file(head_liquid, %r!{%\s+webpack_path js\s+%}!, "/dist/javascript/index.js")
  gsub_file(head_liquid, %r!defer!, "type='module' defer")
  gsub_file(head_liquid, %r!{%\s+webpack_path css\s+%}!, "/dist/styles/index.css")
end

def update_bridgetown_config
  config_file = "bridgetown.config.yml"
  config = YAML.load(File.read(config_file))

  config["development"] = { "url" => "http://localhost:4000" }
  config["destination"] = ".bridgetown"

  File.write(config_file, config.to_yaml)
  gsub_file(config_file, /---\n/, "")
end

main
