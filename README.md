# Purpose

To provide an easy way for Bridgetown users to add Snowpack to a project.

Shoutout to [@andrewmcodes](https://github.com/andrewmcodes) for making this possible.

## Prerequisites

- Ruby >= 2.6
- Bridgetown >= 0.15.0

```bash
bridgetown -v
# => bridgetown 0.19.0
```

This project requires the new `apply` command introduced in Bridgetown
`0.15.0`

## Usage

### New project

```bash
bridgetown new <newsite> --apply="https://github.com/ParamagicDev/bridgetown-automation-snowpack"
```

### Existing Project

```bash
[bundle exec] bridgetown apply https://github.com/ParamagicDev/bridgetown-automation-snowpack
```

## Getting Started

## What this does

This will install the following packages:

- `snowpack`
- `@snowpack/plugin-run-script`
- `@snowpack/plugin-sass`

This will add the following files:

- `snowpack.config.js`

This will modify the following files:

- `bridgetown.config.yml`
- `src/_components/head.liquid`
- `frontend/javascript/index.js`

This will remove the following files:

- `webpack.config.js`
- `sync.js`
- `start.js`

This will uninstall the following packages:

- `@babel/core`
- `@babel/plugin-proposal-class-properties`
- `@babel/plugin-proposal-decorators`
- `@babel/plugin-transform-runtime`
- `@babel/preset-env`
- `babel-loader`
- `browser-sync`
- `concurrently`
- `css-loader`
- `file-loader`
- `mini-css-extract-plugin`
- `node-sass`
- `sass-loader`
- `webpack`
- `webpack-cli`
- `webpack-manifest-plugin`


This will add *OR* replace the following `"scripts"` in your `package.json`.

## scripts:

// package.json
```json
{
  "scripts": {
    "build:bridgetown": "bundle exec bridgetown build",
    "build": "NODE_ENV=production BRIDGETOWN_ENV=production snowpack build",
    "clean:bridgetown": "bundle exec bridgetown clean",
    "restart": "yarn clean:bridgetown && yarn start --reload",
    "start": "snowpack dev",
    "deploy": "yarn clean:bridgetown && yarn build"
  }
}
```

## Commands

### `yarn start`

Starts a dev server @ `localhost:4000` like normal

### `yarn restart`

Reset your cache, cleanup bridgetown, and give you a fresh slate.

### `yarn build`

Normal build command, builds to `output`

### `yarn build:bridgetown`

Builds bridgetown without snowpack. Builds to `.bridgetown`

### `yarn clean:bridgetown`

Wipe bridgetowns cache

### `yarn deploy`

Clean everything and create a fresh `output` directory

## More Info

Go check out https://snowpack.dev for more info on using Snowpack!
