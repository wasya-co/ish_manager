
= Develop =

 RAILS_ENV=development_production be rails c

 RAILS_ENV=dev2 be rails c

= Test =

 ln -s ../../../../../ish_models/spec/factories/ish_models_factories.rb spec/factories
 ln -s ../../../../../spec/m3_factories.rb spec/factories/m3_factories.rb

 . .env-local
 be rspec spec

