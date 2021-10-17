#you need to run the stuff here for this to all work https://discordpy.readthedocs.io/en/stable/intro.html
# I also had to run pip install discord to fix an error, but stack overflow has all the info you would need
from discord.ext import commands

#Looks like this is still usefull after all, possibly needed for aio json stuff?
import aiohttp
import aiofiles

#have a file named "tok" in the same folder with the code DontStealMyToken = "token"
#DONT FORGET TO ADD THE TOK FILE TO THE GITIGNORE!
from tok import DontStealMyToken

#invite your bot to a server with #https://discord.com/oauth2/authorize?client_id=BOT ID HERE&scope=bot

#sets the bot (object?) to be referenced with variable "bot". Also sets the command prefix
bot = commands.Bot(command_prefix="~")

@bot.command(name="hello")
#You need to structure commands like this, but I don't remember why...
async def hello_world(ctx: commands.Context):
    #these strings are optional, but show up when ~help is run
    "Returns a cliche greeting"
    #await is an async command that opens a seperate thread, allowing other commands to be run while this one is ongoing
    #always try to start the new thread as soon as possible as the compute time for code before it makes the bot freeze for that amount of time
    await ctx.send("Hello, world!")

@bot.command(name="test")
async def test_recieved(ctx: commands.Context):
    "Let's you know that the bot is alive"
    await ctx.send("Test passed!")

@bot.command(name="ping")
async def ping(ctx: commands.Context):
    "returns the bot's latency in ms"
    await ctx.send(f"Pong! {round(bot.latency * 1000)}ms")

#file handler commands
@bot.command(name="jason")
async def jason(ctx, *msg):
    if msg[0] == "read":
        async with aiofiles.open("./jason.txt", "r") as jasper:
            output = await jasper.read()
            print(jasper)
            await ctx.send(output)
            await jasper.close()
    if msg[0] == "write":
        allTheWords = ""
        for i in range(1, len(msg) - 1):
            allTheWords += msg[i]
        async with aiofiles.open("./jason.txt", "W") as jasper:
            await jasper.write(allTheWords)
            await jasper.close()


    


@bot.command(name="stop", aliases=['shutdown', 'end'])
#I guess you can add tags like this to specify checks before running a command
#I stole from the internet though, so don't really know how they work
@commands.is_owner()
async def shutdown(ctx):
    "shuts down bot if command issuer is the same as dev acc for bot"
    await ctx.send("seeya")
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
