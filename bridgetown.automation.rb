# frozen_string_literal: true

require 'fileutils'
require "rake"

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

  say 'Installing Snowpack', :green
  install_snowpack

  say 'Adding Snowpack configs', :green
  add_snowpack_files

  say 'Removing Webpack', :blue
  FileUtils.rm 'webpack.config.js' if File.exist?("webpack.config.js")

  say 'Removing start.js and sync.js', :blue
  %w(start.js sync.js).each { |file| FileUtils.rm(file) if File.exist?(file) }

  say 'Removing unneeded npm packages', :blue
  remove_npm_packages
end

def install_snowpack
  run('yarn add snowpack @snowpack/plugin-run-script')
end

def add_snowpack_files
  snowpack_config_js = <<~JAVASCRIPT
    // Snowpack Configuration File
    // See all supported options: https://www.snowpack.dev/#configuration

    /** @type {import("snowpack").SnowpackUserConfig } */
    module.exports = {
      mount: {
        frontend: "/dist",
        output: { url: "/", static: true },
        public: { url: "/", static: true, resolve: false },
      },
      plugins: [
        [
          "@snowpack/plugin-run-script",
          {
            name: "bridgetown",
            cmd: "bin/bridgetown build",
            watch: "$1 --watch --quiet",
          },
        ],
      ],
      devOptions: {
        port: 4000,
        hmrDelay: 1000,
        open: "none",
      },
      buildOptions: {
        metaUrlPath: "output/dist/javascript",
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
    gsub_file("package.json", %r("#{pkg}": ".*",?[\n\r]), "")
  end

  run "yarn install"
end

main
