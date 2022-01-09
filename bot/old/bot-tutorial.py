from discord.ext import commands  # This is the part of discord.py that helps us build bots
from mcstatus import MinecraftServer
import aiohttp
from tok import DontStealMyToken


bot = commands.Bot(command_prefix="!")


@bot.command(name="hello")
async def hello_world(ctx: commands.Context):
    await ctx.send("Hello, world!")

@bot.command(name="test")
async def test_recieved(ctx: commands.Context):
    await ctx.send("Test passed!")

@bot.command(name="ping")
async def ping(ctx: commands.Context):
    await ctx.send(f"Pong! {round(bot.latency * 1000)}ms")

comment = """
@bot.command(name="mc")
async def mc(ctx: commands.Context):
    server = MinecraftServer.lookup("mc.umbriac.com")
    status = server.status()
    await ctx.send(f"Server stats:\n{status.players.online} players online\n{server.ping()}ms ping".format())
"""
@bot.command(name="mc")
async def server(ctx):
        
    server = MinecraftServer.lookup('mc.umbriac.com')
    status = server.status()
    
    await ctx.send("The server has {0} players and replied in {1} ms".format(status.players.online, status.latency))

bot.run(DontStealMyToken)