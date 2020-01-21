# Listen!

This Sinatra app is an experiment with using the listen and notify feature from PostgreSQL alongside websockets as a messaging service.

### Setting up

First things first, you'll need to install required libraries using `bundle`

Next, create your database:

```bash
createdb listen_development
```

From there, you can run `rake db:migrate` to create a comments table, and set up the trigger to listen for insertions to the comments table and send information to  using the `notify` function.

### Running the application

The server can be started using the `puma` command. 

Note: it is not recommended to use the `rackup` command for local development. Rackup in development mode includes middlewares that may interfere with asynchronous applications like this one. If using `rackup` is your preference, the application should be started up in production mode:

```
rackup -E production
```