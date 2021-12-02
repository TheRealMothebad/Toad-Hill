# Toad-Hill
A Toad Hill production // Toad Code.

__Writing a Toad Hill game using a Discord bot__

Structure (objects) brainstorm in [Toad Bot Code Plan](References/Toad%20Bot%20Code%20Plan.md). Original brainstorm in [google doc](https://docs.google.com/document/d/16jl7XO-29eVHYZbQqHHwulq8Uk0VHl2lobnW14eOpwM/edit?usp=sharing).

[LORE](https://docs.google.com/document/d/18cSac9gC4KKNzgSY6ALmh9VTieL2en9fhQKrmIdDlSU/edit?usp=sharing)

## Running ToadBot.py through a discord bot
1. go to https://discord.com/developers
1. probably log in?
1. click "new application" in the top right corner
1. Name your bot and give it a nice picutre
1. go to the "bot" tab on the right and click "add"
1. copy the token into a file titled tok.py in the same direcory as ToadBot.py using the syntax `DontStealMyToken = "token"`
1. invite the bot to a server by going to `https://discord.com/oauth2/authorize?client_id=BOT ID HERE&scope=boto` (replace bot ID)
1. run the bot! you can interact with it in the discord server using the prefix specified in ToadBot.py (we're using `~` at the moment)
