from discord.ext import commands
import discord
import aiohttp
import aiofiles

from tok import DontStealMyToken

bot = commands.Bot(command_prefix="$")

@bot.command(name="hello")
async def hello_world(ctx: commands.Context):
    "Returns a cliche greeting"
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
    "shuts down bot if command issuer is the same as dev acc for bot"
    await ctx.send("seeya")
    await ctx.bot.close()

@bot.event
async def on_command_error(ctx, error):
    if isinstance(error, discord.ext.commands.errors.NotOwner):
        await ctx.send("You are not cool enough to do that.")

bot.run(DontStealMyToken)
