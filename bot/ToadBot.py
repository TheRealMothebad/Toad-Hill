# you need to run the stuff here for this to all work https://discordpy.readthedocs.io/en/stable/intro.html
# I also had to run pip install discord to fix an error, but stack overflow has all the info you would need
# https://discord.com/developers/applications/ for all the permissions and stuff
# invite your bot to a server with https://discord.com/oauth2/authorize?client_id=BOT-ID-HERE&scope=bot

import datetime
import discord
from discord.ext import commands

import aiohttp
import aiofiles

import json
import time

#have a file named "tok.py" in the same folder with the code DontStealMyToken = "token"
#DONT FORGET TO ADD THE TOK FILE TO THE GITIGNORE!
from tok import DontStealMyToken

#sets the bot (object?) to be referenced with variable "bot". Also sets the command prefix
intents = discord.Intents.all()
bot = commands.Bot(command_prefix="~", intents=intents)

# You need to structure commands like this, but I don't remember why...
# (that's just how the discord library reads stuff i guess?)

@bot.command(name="test")
async def test(ctx: commands.Context):
    # these strings are optional, but show up when ~help is run
    "lets you know that the bot is alive"
    # await is an async command that opens a seperate thread, allowing other commands to be run while this one is ongoing
    # always try to start the new thread as soon as possible as the compute time for code before it makes the bot freeze for that amount of time
    await ctx.send("Test passed!")

@bot.command(name="ping")
async def ping(ctx: commands.Context):
    "returns the bot's latency in ms"
    await ctx.send(f"Pong! {round(bot.latency * 1000)}ms")

@bot.command(name="io")
async def io(ctx, op, *, msg=None):
    "interact with The File; use '~io read' or '~io add <text>'"
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

@bot.command(name="audioo")
# this should say join(ctx, self): but that's making it freeze
async def audioo(ctx):
    "join voice channel of issuer and play john (r)'s intro music"
    await ctx.send("note: you must be in a voice channel for this to work")
    issuer = ctx.message.author
    voice_channel = issuer.voice.channel
    await ctx.send("attempting to join " + str(issuer) + "'s voice channel: " + str(voice_channel))
    voice = discord.utils.get(ctx.guild.voice_channels, name=voice_channel.name)
    # requires PyNaCl library (pip install pynacl)
    vc = await voice.connect()

    # wait for the join chime
    await ctx.send("Now playing 'Toad Hill Ep. 2 Intro-y Bits' [0:54] by John Reed...")
    await ctx.send("Commands issued during the track's duration will not be processed until after the track has ended. Good luck!")
    time.sleep(1)
    vc.play(discord.FFmpegPCMAudio(executable="/usr/bin/ffmpeg", source="../music/john/intro-johnr.wav"))
    # sleep while audio is playing then disconnect
    while vc.is_playing():
        time.sleep(.1)
    await vc.disconnect()



@bot.command(name="jason")
async def jason(ctx, op, key=None, *, val=None):
    "use '~jason read [key]', '~jason write [key] [value]', or '~jason dump'"
    if op == "dump":
        async with aiofiles.open("./toad-archives.json", "r") as jasper:
            readout = await jasper.read()
            await ctx.send(readout)
            await jasper.close()
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


@bot.command(name="newplayer")
async def newplayer(ctx, *, name=None):
    "add a new character! use '~newplayer <character name>'"
    issuer = ctx.message.author
    if name == None:
        await ctx.send("You must specify a name (like '~newplayer Example Name')")
    else:
        await ctx.send("You are " + str(issuer))
        await ctx.send("adding player '" + name + "'...")
        print("Creating character '" + name + "' for " + str(issuer) + "...")
        filename = name.replace(" ", "-").lower()
        filepath = "./players/" + filename + ".json"
        async with aiofiles.open(filepath, "w") as playerfile:
            await playerfile.write("{}")
            await playerfile.close()
        async with aiofiles.open(filepath, "r") as playerfile:
            readout = await playerfile.read()
            parsed = json.loads(readout)
            await playerfile.close()
        parsed["name"] = str(name)
        parsed["owner"] = str(issuer)
        parsed["location"] = None
        parsed["inventory"] = None
        await ctx.send(str(json.dumps(parsed)))
        async with aiofiles.open(filepath, "w") as playerfile:
            await playerfile.write(json.dumps(parsed))
            await playerfile.close()


@bot.command(name="chooseplayer")
async def chooseplayer(ctx, *, name=None):
    "select your character (use '~chooseplayer <name>')"
    issuer = ctx.message.author
    if name == None:
        await ctx.send("You must specify a name (like '~chooseplayerExample Name')")
    else:
        filename = name.replace(" ", "-").lower()
        filepath = "./players/" + filename + ".json"
        async with aiofiles.open(filepath, "r") as playerfile:
            readout = await playerfile.read()
            parsed = json.loads(readout)
            await playerfile.close()
        if str(issuer) == str(parsed["owner"]):
            await ctx.send("This will work! " + str(issuer) + " owns " + str(parsed['name']) + ".")
        else:
            await ctx.send("Error: you do not own " + str(parsed['name']) + ". Please select a character you created, or create a new character.")


@bot.command(name="stop", aliases=['shutdown', 'end', 'quit', 'exit'])
@commands.is_owner()
# I guess you can add tags like this to specify checks before running a command
# I stole from the internet though, so don't really know how they work
async def shutdown(ctx):
    "shuts down bot (provided command issuer is the same as dev acc for bot)"
    issuer = ctx.message.author
    timestamp = str(datetime.datetime.now())
    await ctx.send(timestamp + ": toad bot is departing, by request of " + str(issuer))
    print(":: ToadBot signing off at " + timestamp + " by request of " + str(issuer))
    # output the story so far to backup.txt with timestamp when you exit
    async with aiofiles.open("./backup.txt", "a+") as bkp:
        await bkp.write("\n\n---- ToadBot signing off at " + timestamp + " by request of " + str(issuer) + " ----\n")
        print("writing latest backup of ./story-plaintext.txt to ./backup.txt...")
        await bkp.write(":: latest story-plaintext.txt:\n")
        async with aiofiles.open("./story-plaintext.txt", "r") as latest:
            readout = await latest.read()
            await bkp.write(readout)
            await latest.close()
        print("writing latest backup of ./toad-archives.json to ./backup.txt...")
        await bkp.write(":: latest toad-archives.json:\n")
        async with aiofiles.open("./toad-archives.json", "r") as latest:
            readout = await latest.read()
            await bkp.write(readout)
            await latest.close()
        await bkp.close()
    await ctx.bot.close()


# this is the general catch for errors, not very clean, but it works
@bot.event
async def on_command_error(ctx, error):
    # my approach to this is just have an if else chain to catch errors...
    if isinstance(error, discord.ext.commands.errors.NotOwner):
        issuer = ctx.message.author
        print(str(issuer) + " attempted to Stop the Bot unsuccessfully")
        async with aiofiles.open("./backup.txt," "a+") as bkp:
            await bkp.write(str(datetime.datetime.now()) + ": " + str(issuer) + " tried unsuccessfully to Stop the Bot.")
            await bkp.close()
        await ctx.send("You are not cool enough to Stop the Toad Boat, " + str(issuer) + ".")
    else:
        await ctx.send("ERROR: " + str(error))
        print("ERROR: " + str(error))

# this starts the loop that is the bot
# the code essentialy gets stuck here as it just constantly loops over the @bot.whatever things waiting for triggers
# I think the loop starts at bot = commands.Bot() but am not sure
print("ToadBot going online...")
bot.run(DontStealMyToken)

# if you want code to run after the bot is shut down, put it here
# (this will run after a ^C on the local side too; it's after the loop is broken, in any case)
print("ToadBot going offline...")
