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
# ruby
rbenv install 2.3.1
rbenv rehash
gem install bundler

# bower
npm install -g bower

# mulang
wget https://github.com/mumuki/mulang/releases/download/v3.4.0/mulang
mv mulang bin/
chmod +x bin/mulang

# rungs
wget https://github.com/gobstones/gobstones-cli/releases/download/v1.3.3/rungs-ubuntu64 -O rungs
chmod u+x rungs
sudo mv rungs /usr/bin/rungs
```

## Install local dependencies

```bash
bundle install
bower install
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
