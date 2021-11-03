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

with open("./toad-archives.json", "r") as archive:
    n = archive.read()
    archive.close()
    
k = json.loads(n)
print(k)
print(k["player"])
#replace value
k["player"] = "geurauldde"
print(k)
print(k["player"])

with open("./toad-archives.json", "w") as archive:
    archive.write(json.dumps(k))
    archive.close()
