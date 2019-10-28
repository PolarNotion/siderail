# Polar Notion: Siderail

> _Get started on the right track_

Siderail is an application generator that provides:

- a pile of must-have gems that represent the way we work
- specifications set up using RSpec
- admin stuff: roles, routes, controllers, interface
- event/pageview tracking
- a standard for our projects to share
- a [Rails Application Generator](https://guides.rubyonrails.org/rails_application_templates.html) that is easy to keep updated
- always growing and improving with real world usage

## Start Here

Starting a new project? Start with Siderail!

TODO

## Troubleshooting

### Ruby Versions

Ruby is our language of choice, but there are many versions of the language and many more to come as the project is very popular and active. You may have ruby installed already, but in a different version than Siderail expects.

The Ruby version is specified in two places, and they should match:
- [the .ruby-version file](https://github.com/PolarNotion/siderail/blob/master/.ruby-version)
- [near the top of the Gemfile](https://github.com/PolarNotion/siderail/blob/master/Gemfile)

The `.ruby-version` file is a hint to the various Ruby version managers out there to help your system automatically switch between rubies without having to think about it. The `Gemfile` keeps a version as a sanity check when installing dependencies, as some gems care very much what version of ruby they are running in.

Modern practice is to use a Ruby version manager, here are a few:
- [rvm](https://rvm.io/): the original, attempts to do all the things, best for novices
- [rbenv](https://github.com/rbenv/rbenv): does less, expects user to know more
- [chruby](https://github.com/postmodern/chruby): similar benefits as rbenv, opinionated developers should compare and contrast these two

You could:

1. Select and install a version manager
2. Read the docs about how to install rubies
3. Install the ruby version specified in `.ruby-version`
4. Running `bundle install` should now work!
5. Still not working? Ask for help!

### PostgreSQL and the `pg` gem

Need Postgres? We use Postgres.app in development for ease and clarity. You can (get it here)[https://postgresapp.com/]

Having trouble installing the `pg` gem? Not surprising! Rubygems needs to know where your `pg_config` binary is in order to compile the native bits correctly. You'll have to dig it up in your system and pass it during installation.

I just found mine here:

```
/Applications/Postgres.app/Contents/Versions/11/bin/pg_config
```

...when you find yours, you can install `pg` by itself with something like this:

```
gem install pg -v '1.1.4' --source 'https://rubygems.org/' -- --with-pg_config='/Applications/Postgres.app/Contents/Versions/11/bin/pg_config'
```

Success? Now go back and run `bundle install`, when it gets to the `pg` gem it will know what to do.

### Yarn

Ya gonna need it in Rails 6 land!

https://yarnpkg.com/lang/en/docs/install/

### Homebrew

TODO

### ImageMagick / RMagick / MiniMagick

TODO

### Sidekiq / Redis

TODO
