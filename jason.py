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
print("toad-archives.json readout: ")
print(k)
print("Player: " + k["player"])
print()

# replace value
newt = input("enter new player name: ")
print(newt)
# only works in python3 apparently, no clue why. so i just had to specify 'python3 jason.py' but that's probably default for you who knows
k["player"] = newt
print(k)
# write over json file with new data table
with open("./toad-archives.json", "w") as archive:
    archive.write(json.dumps(k))
    archive.close()
