![build](https://github.com/ParamagicDev/bridgetown-automation-snowpack/workflows/build/badge.svg)

# Purpose

To provide an easy way for Bridgetown users to add Snowpack to their project.

## Prerequisites

- Ruby >= 2.6
- Bridgetown >= 0.17.0

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

### Adding controllers

Controllers should be placed in the `./frontend/javascript/controllers/` directory.
Make sure the controllers follow the `[name]_controller.js` convention.
Check out more @ [snowpackjs.org](https://snowpackjs.org)

## Testing the "apply" command locally

Right now there is one big integration test which simply
checks that the files were created for Stimulus in a new bridgetown project.

In order for the tests to pass, you must first push the branch you're working on and then
wait for Github to update the raw file so the remote automation test will pass

```bash
git clone
https://github.com/ParamagicDev/bridgetown-automation-snowpack/
cd bridgetown-automation-snowpack
bundle install
bundle exec rake test
```

