
= Setup =

Run or add to your rc:

  alias be='bundle exec '

The app driving this library is in test/dummy. You need to obtain the credentials file from me and put it in test/dummy/ . Then, create a user:

  cd test/dummy
  be rake m3_dummy:create_user

Start the server:

  cd test/dummy
  be rails s

Then you can login: http://localhost:3000

Note: all of the development is done in the app/ folder. The code in test/dummy/app/ is only scaffolding and is not used in production.

= Test =

 cd test/dummy
 be rspec spec



