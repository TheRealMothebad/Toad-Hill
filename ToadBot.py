from discord.ext import commands

import aiohttp

from tok import DontStealMyToken

bot = commands.Bot(command_prefix=">")

@bot.command(name="hello")
async def hello_world(ctx: commands.Context):
    "hello!"
    
    await ctx.send("hi, i'm a toad. how about you?")

@bot.command(name="test")
async def test_recieved(ctx: commands.Context):
    "it's a test. TEST!"
    await ctx.send("yup we good, test good test yes test ok good job")

@bot.command(name="ping")
async def ping(ctx: commands.Context):
    "returns the bot's latency in ms"
    await ctx.send(f"pling! {round(bot.latency * 1000)}ms")

@bot.command(name="stop")
@commands.is_owner()
async def shutdown(ctx):
    "shuts down bot (if command issuer is the same as dev acc for bot)"
    await ctx.send("ok bye have a good, thanks for having me")
    await ctx.bot.close()

@bot.event
async def on_command_error(ctx, error):
    if isinstance(error, discord.ext.commands.errors.NotOwner):
        await ctx.send("You are not cool enough to do that. (make note if this error ever shows up; i have absolutely no idea what it's for)")

bot.run(DontStealMyToken)
