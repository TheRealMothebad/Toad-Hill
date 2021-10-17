import discord
from discord.ext import commands

import aiofiles
import aiohttp

import json

from tok import DontStealMyToken

bot = commands.Bot(command_prefix="%")

@bot.command(name="test")
async def test_recieved(ctx: commands.Context):
    "it's a test"
    await ctx.send("yup we good, test good test yes test ok good job")

@bot.command(name="ping")
async def ping(ctx: commands.Context):
    "returns the bot's latency in ms"
    await ctx.send(f"pling! {round(bot.latency * 1000)}ms")

@bot.command(name="current")
async def hello_world(ctx: commands.Context):
    "print the current progress in the story"
    await ctx.send("hi sorry this feature doesn't actually exist yet, we'll get there")

@bot.command(name="add")
async def hello_world(ctx: commands.Context):
    "add to the story"
    await ctx.send("hi sorry this feature doesn't actually exist yet, we'll get there")
    async with aiofiles.open('./test.json', mode='a+') as f:
        contents = await f.read()
    await ctx.send(contents)

@bot.command(name="readme")
async def hello_world(ctx: commands.Context):
    "print README.md"
    async with aiofiles.open('./README.md', mode='r') as f:
        contents = await f.read()
    await ctx.send(contents)

@bot.command(name="json")
async def hello_world(ctx: commands.Context):
    "read json file entry"
    with open('./test.json', mode='r') as f:
        contents = json.load(f.read())
    await ctx.send(contents)

@bot.command(name="chp")
async def hello_world(ctx: commands.Context):
    "chapter selection menu"
    await ctx.send("hi sorry this feature doesn't actually exist yet, we'll get there")


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
        for i in range(1, len(msg)):
            allTheWords += msg[i] + " "
        print(allTheWords)
        await ctx.send(allTheWords)
        async with aiofiles.open("./jason.txt", "a+") as jasper:
            await jasper.write(allTheWords)
            await jasper.write("\n")
            await jasper.close()    


@bot.command(name="stop", aliases=['shutdown', 'end'])
@commands.is_owner()
async def shutdown(ctx):
    "shuts down bot (if command issuer is the same as dev acc for bot)"
    await ctx.send("ok bye have a good, thanks for having me")
    await ctx.bot.close()

@bot.event
async def on_command_error(ctx, error):
    if isinstance(error, discord.ext.commands.errors.NotOwner):
        await ctx.send("foolish mortal, you have no power over TobiToadBoat")

bot.run(DontStealMyToken)

