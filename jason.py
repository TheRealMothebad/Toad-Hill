"""
import discord
from discord.ext import commands

import aiohttp
import aiofiles
"""

import json

# very basic parsing

x = '{ "player":"gerald", "sector":"main hall", "toads":74 }'

y = json.loads(x)

print(y)
print(y["player"])





# read a file

with open("./toad-archives.json", "r+") as archive:
    n = archive.read()
    k = json.loads(n)
    print(k)
    print(k["player"])
    archive.close()
