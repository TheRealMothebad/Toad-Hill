#you need to run the stuff here for this to all work https://discordpy.readthedocs.io/en/stable/intro.html
# I also had to run pip install discord to fix an error, but stack overflow has all the info you would need
from discord.ext import commands

#donno if we need this, might have just been for the mc server lookup shenanegins
import aiohttp

#have a file named "tok" in the same folder with the code DontStealMyToken = "token"
#DONT FORGET TO ADD THE TOK FILE TO THE GITIGNORE!
from tok import DontStealMyToken

#invite your bot to a server with #https://discord.com/oauth2/authorize?client_id=BOT ID HERE&scope=bot

bot = commands.Bot(command_prefix="~")

@bot.command(name="hello")
async def hello_world(ctx: commands.Context):
    await ctx.send("Hello, world!")

@bot.command(name="test")
async def test_recieved(ctx: commands.Context):
    await ctx.send("Test passed!")

@bot.command(name="ping")
async def ping(ctx: commands.Context):
    await ctx.send(f"Pong! {round(bot.latency * 1000)}ms")

bot.run(DontStealMyToken)