[![Build Status](https://travis-ci.org/mumuki/mumuki-qsim-server.svg?branch=master)](https://travis-ci.org/mumuki/mumuki-qsim-server)
[![Code Climate](https://codeclimate.com/github/mumuki/mumuki-qsim-server/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumuki-qsim-server)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumuki-qsim-server/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumuki-qsim-server)

# Install the server

## Clone the project

```
git clone https://github.com/mumuki/mumuki-qsim-server 
cd mumuki-qsim-server
```

## Install Ruby

```bash
rbenv install 2.0.0-p481
rbenv rehash
gem install bundler
```

## Install Dependencies

```bash
bundle install
```

# Run the server

```bash
RACK_ENV=development bundle exec rackup -p 4567
```



