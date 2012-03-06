  source 'http://rubygems.org'

  gem 'rails', '~>3.0.11'

  gem 'blacklight', '~> 3.1.2'
  gem 'hydra-head', '~> 3.3.0'
  gem 'rbx-require-relative', '=0.0.5'

  #  We will assume you're using devise in tutorials/documentation. 
  # You are free to implement your own User/Authentication solution in its place.
  gem 'devise'

  group :production do
	 gem 'pg'
  end

  # For testing.  You will probably want to use all of these to run the tests you write for your hydra head
  group :development, :test do 
	 # We will assume that you're using sqlite3 for testing/demo, 
  	 # but in a production setup you probably want to use a real sql database like mysql or postgres
  	 gem 'sqlite3'

         gem 'solrizer-fedora', '>=1.2.2'
         gem 'ruby-debug'
         gem 'rspec'
         gem 'rspec-rails', '>=2.5.0'
         gem 'mocha'
         gem 'cucumber-rails'
         gem 'database_cleaner'
         gem 'capybara'
         gem 'bcrypt-ruby'
         gem "jettywrapper"

         # Added 
         gem 'net-http-digest_auth'
         gem 'rubyhorn', :git => "git://github.com/variations-on-video/rubyhorn.git"
         gem 'felixwrapper', :git => "git://github.com/cjcolvar/felixwrapper.git"
         gem 'red5wrapper', :git => "git://github.com/cjcolvar/red5wrapper.git"

  end # (leave this comment here to catch a stray line inserted by blacklight!)
