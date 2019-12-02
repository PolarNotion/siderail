# Polar Notion: Siderail

> _Get started on the right track_

Siderail is an application generator that provides:

- a pile of must-have gems that represent the way we work
- specifications set up using RSpec
- admin stuff: roles, routes, controllers, interface
- event/pageview tracking
- a standard for our projects to share
- a [Rails Application Template](https://guides.rubyonrails.org/rails_application_templates.html) that is easy to keep updated
- always growing and improving with real world usage

> Looking for the old version of Siderail that you just clone directly? [It is tagged, here](https://github.com/PolarNotion/siderail/tree/clone-style).

## Start Here

Starting a new project? Start with Siderail! It's as easy as:

```
rails new APPLICATION_NAME -T -d postgresql -m https://raw.githubusercontent.com/PolarNotion/siderail/master/application_template.rb
```

What's happening here?
- `rails new` is our old friend, ready to faithfully generate a Rails app for us
- replace `APPLICATION_NAME` with the real name of your app
- `-T` means "don't generate normal rails unit tests" (we use RSpec!)
- `-d postgresql` means we use Postgres. We always use Postgres.
- `-m ...` is our application template, which is where the magic happens

### Make It The Default (optional)

Rails will respect generator settings placed in a file at `~/.railsrc`, which should look like this:
```
-T
-d postgresql
-m https://raw.githubusercontent.com/PolarNotion/siderail/master/application_template.rb
```
...and now we can simply...
```
rails new APPLICATION_NAME
```
...and it'll do the magic without all the typing!


## Changing/Updating Siderail

Need to modify what Siderail generates for us? Awesome!

There's a few places to learn about how it works:
- read [the template file itself](https://github.com/PolarNotion/siderail/blob/master/application_template.rb) to see what it's doing
- read [the Guide about Rails Application Templates](https://guides.rubyonrails.org/rails_application_templates.html)
- read about [Thor](https://github.com/erikhuda/thor/wiki), a powerful CLI framework that these templates are built atop

### Adding a New Static File

Need to add a new file to the generated app without any template-generation-time dynamic bits?

- add the file to the Siderail repo in the same location it will be in the generated app (create directories as needed)
- add a line to `application_template.rb` to copy it where it goes:
  - `copy_file "path/to/file.rb"`, or...
  - `copy_file "path/to/file.rb", force: true` if you need to overwrite what's there

### Adding a New Dynamic File

Need to add a file that gets part of its contents generated at template-generation-time?

- add the file to the Siderail repo in the same location it will be in the generated app (create directories as needed)
- add a `.tt` extension to the file (leave its original extension intact)
- change any existing template directives to be escaped directives, like so:
  - `<%` becomes `<%%`
  - `<%-` becomes `<%%-`
  - `<%=` becomes `<%%=`
  - `%>` stays the same, **do not double closing tags**
  - etc
  - these will **not** be evaluated at template-time, rather they will return to their unescaped forms, ready to be executed by rails as normal
- add your own dynamic directives (`<%=` etc), which **will** be evaluated at template-time
- add a template line to `application_template.rb`:
  - `template "path/to/file.rb.tt"`, or...
  - `template "path/to/file.rb", force: true` if you need to overwrite what's there

### Making New Questions

Need to make something optional and allow the user to decide whether to include it or not?

Let's look at how the "Sidekiq?" question is implemented:

```ruby
def confirm_optional_libs
  puts yellow("Select Options:")
  sidekiq? # call all question methods at once in this method
  redis?
end

# create a method for the question you want to ask
def sidekiq?
  ask_once("Sidekiq?") # use the ask_once helper method that remembers the response
end

def redis?
  # notice how the redis? question answers itself if sidekiq? is already true
  sidekiq? || ask_once("Redis?")
end

# read source for ask_once if curious!
def ask_once(question)
  # ...
end
```

The steps:
- create a method to represent the question
- use the `ask_once` helper in the question method
- short circuit if another question precludes this one
  - e.g. if sidekiq? is yes, redis? is automatically yes
- call the question method in the `confirm_optional_libs` method
  - put it in order if questions rely on each other:
    - e.g. ask sidekiq? _before_ asking redis?

### Using Answers in Templates

Need to do something dynamically at template-generation-time based on the answer to a question? You can simply call the question method again, it will evaluate true/false based on the prior answer.

In code:

```ruby
if sidekiq?
  # do a thing
end
```

In templates (`.tt` files):

```erb
<%- if sidekiq? %>
Do sidekiq-specific stuff!
<% end %>
```

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
