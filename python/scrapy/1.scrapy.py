# scrapy.py

from scrapy import Item, Field

class DmozItem(Item):
    title = Field()
    link = Field()
    desc = Field()
