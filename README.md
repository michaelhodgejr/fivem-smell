# fivem-smell
Allows the ability for a player on a fivem server to attach a smell to their character for roleplay purposes.

# Installing
Clone the repository into your server-data directroy

```
  git clone git@github.com:michaelhodgejr/fivem-smell.git
```

Add the following to your server.cfg 

```
  start fivem-smell
```

# Commands

This resource makes the following commands available:

```
 /smell - Outputs the current smell of the player
 /setsmell - Sets the smell for the current player i.e '/setsmell "Alcohol and Poor Life Choices"' Note that the double quotes are only needed if you wish to include multiple words as the smell. '/smell garbage' works just as well
 /clearsmell - Clears the current smell from the player
```

# How it Works

It works by finding the player closest to the current player and triggers a notification that states "You notice a smell of [smell] on a nearby player". If you wish to edit this you can do so in the ./client/main.lua file
Once a player has been notified they will only be sent that notification once. If the player changes their smell to something else they will receive the notification again. 

# Forking and Contributing

Feel free to fork the resource and to submit pull requests. 
