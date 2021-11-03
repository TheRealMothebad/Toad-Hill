import json

x = '{ "player":"gerald", "sector":"main hall", "toads":74 }'

y = json.loads(x)

print(y)
print(y["player"])
