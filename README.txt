
= Setup =

The app driving this library is in test/dummy.

  cd test/dummy
  be rails s

Then you may create your user:

  be rake m3_dummy:create_user

Then you can login: http://localhost:3000

Note: all of the development is done in the app/ folder. The code in test/dummy/app/ is only scaffolding and is not used in production.



= Test =
 cd test/dummy && be rspec spec/controllers



