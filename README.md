[![Build Status](https://travis-ci.org/mumuki/mumuki-gobstones-runner.svg?branch=master)](https://travis-ci.org/mumuki/mumuki-gobstones-runner)
[![Code Climate](https://codeclimate.com/github/mumuki/mumuki-gobstones-runner/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumuki-gobstones-runner)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumuki-gobstones-runner/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumuki-gobstones-runner)

# Install the server

## Clone the project

```
git clone https://github.com/mumuki/mumuki-gobstones-runner
cd mumuki-gobstones-runner
```

## Install global dependencies

```bash
rbenv install 2.3.1
rbenv rehash
gem install bundler
```

## Install local dependencies

```bash
bundle install
./bin/pull_worker.sh
```

# Run tests

```bash
bundle exec rake
```

# Run the server

```bash
RACK_ENV=development bundle exec rackup -p 4000 --host 0.0.0.0
```

# Deploy docker image

```bash
cd worker/
# docker login
docker rmi mumuki/mumuki-gobstones-worker
docker build -t mumuki/mumuki-gobstones-worker .
docker push mumuki/mumuki-gobstones-worker
```
