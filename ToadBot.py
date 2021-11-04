#you need to run the stuff here for this to all work https://discordpy.readthedocs.io/en/stable/intro.html
# I also had to run pip install discord to fix an error, but stack overflow has all the info you would need
import datetime
import discord
from discord.ext import commands

#Looks like this is still usefull after all, possibly needed for aio json stuff?
import aiohttp
import aiofiles

import json

#have a file named "tok" in the same folder with the code DontStealMyToken = "token"
#DONT FORGET TO ADD THE TOK FILE TO THE GITIGNORE!
from tok import DontStealMyToken

#invite your bot to a server with #https://discord.com/oauth2/authorize?client_id=BOT ID HERE&scope=bot

#sets the bot (object?) to be referenced with variable "bot". Also sets the command prefix
bot = commands.Bot(command_prefix="~")

@bot.command(name="test")
#You need to structure commands like this, but I don't remember why...
async def hello_world(ctx: commands.Context):
    #these strings are optional, but show up when ~help is run
    "Lets you know that the bot is alive"
    #await is an async command that opens a seperate thread, allowing other commands to be run while this one is ongoing
    #always try to start the new thread as soon as possible as the compute time for code before it makes the bot freeze for that amount of time
    await ctx.send("Test passed!")

@bot.command(name="ping")
async def ping(ctx: commands.Context):
    "returns the bot's latency in ms"
    await ctx.send(f"Pong! {round(bot.latency * 1000)}ms")

#file handler commands
"""
@bot.command(name="io")
async def io(ctx, op, *, msg=None):
    "use '~io read' or '~io add <text>'"
    if op == "read":
        async with aiofiles.open("./story-plaintext.txt", "r") as folder:
            readout = await folder.read()
            print(readout)
            await ctx.send(readout)
            await folder.close()
    if op == "add":
        await ctx.send(msg)
        async with aiofiles.open("./story-plaintext.txt", "a+") as folder:
            await folder.write(msg)
            await folder.write("\n")
            await folder.close()
"""

@bot.command(name="jason")
async def jason(ctx, op, key=None, *, val=None):
    "'~jason read [key]', '~jason write [key] [value]', or '~jason dump'"
#    if op == "dump":
#        await ctx.send(readout)
    if op == "read":
        async with aiofiles.open("./toad-archives.json", "r") as jasper:
            readout = await jasper.read()
            parse = json.loads(readout)
            await ctx.send(parse[key])
            await jasper.close()
    if op == "write":
        async with aiofiles.open("./toad-archives.json", "r") as jasper:
            readout = await jasper.read()
            parse = json.loads(readout)
            await jasper.close()
        parse[key] = str(val)
        async with aiofiles.open("./toad-archives.json", "w") as jasper:
            await jasper.write(json.dumps(parse))
            await jasper.close()

    


@bot.command(name="stop", aliases=['shutdown', 'end', 'quit', 'exit'])
@commands.is_owner() #I guess you can add tags like this to specify checks before running a command
#I stole from the internet though, so don't really know how they work
async def shutdown(ctx):
    "shuts down bot (provided command issuer is the same as dev acc for bot)"
    await ctx.send("toad bot is departing")
    # output the story so far to backup.txt with timestamp when you exit
    async with aiofiles.open("./story-plaintext.txt", "r") as latest:
        readout = await latest.read()
        async with aiofiles.open("./backup.txt", "a+") as bkp:
            await bkp.write("\n\nToadBot signing off at ")
            await bkp.write(str(datetime.datetime.now()) + "::\n")
            await bkp.write(readout)
            await bkp.close()
        await latest.close()
    await ctx.bot.close()


#this is the general catch for errors, not very clean, but it works
@bot.event
async def on_command_error(ctx, error):
    #my approach to this is just have an if else chain to catch errors...
    if isinstance(error, discord.ext.commands.errors.NotOwner):
        await ctx.send("You are not cool enough to do that.")

#this starts the loop that is the bot
#the code essentialy gets stuck here as it just constantly loops over the @bot.whatever things waiting for triggers
#I think the loop starts at bot = commands.Bot() but am not sure
bot.run(DontStealMyToken)

#if you want code to run after the bot is shut down, put it here
