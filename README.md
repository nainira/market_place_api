# market api

### shoulda-matchers with guard issue

gem 'shoulda-matchers', require: false
...and then in spec/spec_helper require it manually:

require 'shoulda-matchers'