import datetime
import discord
from discord.ext import commands

import aiofiles
import aiohttp

import json

from tok import DontStealMyToken

bot = commands.Bot(command_prefix="%")

@bot.command(name="current")
async def hello_world(ctx: commands.Context):
    "print the current progress in the story"
    await ctx.send("hi sorry this feature doesn't actually exist yet, we'll get there")

"""#file handler commands
@bot.command(name="jason")
async def jason(ctx, op, *, msg=None):
    "file i/o. use 'jason read' to show contents, and 'jason write [words]' to append."
    if op == "read":
        async with aiofiles.open("./jason.txt", "r") as jasper:
            jam = await jasper.read()
            print(jam)
            await ctx.send(jam)
            await jasper.close()
    if op == "write":
        await ctx.send(msg)
        async with aiofiles.open("./jason.txt", "a+") as jasper:
            await jasper.write(msg)
            await jasper.write("\n")
            await jasper.close()"""

#implement jason as plaintext file adding
@bot.command(name="story-p")
async def jason(ctx, op, *, msg=None):
    "plaintext: use '%story-p read' or '%story-p add [words]'."
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

"""@bot.command(name="json")
async def hello_world(ctx: commands.Context):
    "read json file entry"
    with open('./test.json', mode='r') as f:
        contents = json.load(f.read())
    await ctx.send(contents)"""

@bot.command(name="chp")
async def hello_world(ctx: commands.Context):
    "chapter selection menu"
    await ctx.send("hi sorry this feature doesn't actually exist yet, we'll get there")

@bot.command(name="_ping")
async def ping(ctx: commands.Context):
    "returns the bot's latency in ms"
    await ctx.send(f"pling! {round(bot.latency * 1000)}ms")

@bot.command(name="stop", aliases=['shutdown', 'end'])
@commands.is_owner()
async def shutdown(ctx):
    "shuts down bot (if command issuer is the same as dev acc for bot)"
    await ctx.send("toad bot is departing")
    async with aiofiles.open("./story-plaintext.txt", "r") as done:
        readout = await done.read()
        async with aiofiles.open("./backup.txt", "a+") as bkp:
            await bkp.write("logoff new message\n")
#            await bkp.write(datetime.datetime.now())
            await bkp.write(readout)
            await bkp.close()
        await done.close()
    await ctx.bot.close()

@bot.event
async def on_command_error(ctx, error):
    if isinstance(error, discord.ext.commands.errors.NotOwner):
        await ctx.send("foolish mortal, you have no power over TobiToadBoat")

bot.run(DontStealMyToken)

