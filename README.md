![build](https://github.com/ParamagicDev/bridgetown-automation-snowpack/workflows/build/badge.svg)

# Purpose

To provide an easy way for Bridgetown users to add Snowpack to their project.

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


This will **NOT** remove or add `"scripts"` to your `package.json`.
Those must be added manually.

## Recommended scripts:

// package.json
```json
{
  "scripts": {
    "build:src": "bin/bridgetown build",
    "build": "NODE_ENV=production BRIDGETOWN_ENV=production snowpack build",
    "clean:src": "bundle exec bridgetown clean",
    "restart": "yarn clean:src && yarn start --reload",
    "start": "snowpack dev"
  }
}
```
