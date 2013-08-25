from scrapy.selector import HtmlXPathSelector
from scrapy.spider import BaseSpider
from douban.items import DoubanItem

class DoubanComSpider(BaseSpider):
    name = 'douban.com'
    allowed_domains = ['douban.com']
    start_urls = ['http://www.douban.com/people/frankwang/groups']

    def parse(self, response):
        hxs = HtmlXPathSelector(response)
        item = DoubanItem()
        item['url'] = hxs.select('//dt/a/@href').extract()
        item['name'] = hxs.select('//dt/a/img/@alt').extract()
        return item
