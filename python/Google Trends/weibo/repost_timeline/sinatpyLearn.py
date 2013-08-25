# 应用python编写简单新浪微博应用（一）
# http://beauty.hit.edu.cn/myStudy/Product/doc.2011-09-05.3305539365


'''
=============转载请注明出处=============

　　首先，你要有一个新浪微博账号。
　　申请页面：http://weibo.com

　　其次，你要在新浪微博的开发平台中创建一个应用，获取自己专属的App Key和App Secret。
　　申请页面：http://open.weibo.com/development

　　再次，你要下载一个sinatpy开发包，这个开发包里没有setup.py，手工解压后将weibopy目录拷贝至python的库目录下即可。
　　下载页面：http://code.google.com/p/sinatpy/downloads/list
　　特别注意：据个人测试，该开发包最低支持python2.4，但需要同时拷贝simplejson目录至python的库目录下。

　　至此，一切条件均已齐备。虽然我下面会给出具体的代码范例说明如何调用开发包中的相应函数完成基本的应用授权、获取用户信息、发布微博消息、获取微博消息列表、获取指定微博消息等操作，但还是希望开发者能先行详细阅读新浪微博开发平台中提供的所有文档，特别是授权机制说明，我在文中不会再赘述相关背景资料。
　　文档页面：http://open.weibo.com/wiki
'''

# 一、应用验证相关代码
　　以下的代码属于基础代码，之后各个步骤的代码均需承接以下代码。

from weibopy.auth import OAuthHandler
from weibopy.api import API
import webbrowser

#此应用的开发者密钥(此处应替换为创建应用时获取到的开发密钥)
APP_KEY = '1234567890';
APP_SECRET = 'abcdefghijklmnopqrstuvwxyz123456';

#设定网页应用回调页面(桌面应用设定此变量为空)
BACK_URL = "http://beauty.hit.edu.cn/backurl";
#验证开发者密钥.
auth = OAuthHandler( APP_KEY, APP_SECRET, BACK_URL );
# 二、应用授权相关代码
#获取授权页面网址.
auth_url = auth.get_authorization_url();
webbrowser.open(auth_url)
verifier = raw_input('PIN: ').strip() 
#取出请求令牌密钥(桌面应用跳过此处)
rtKey = auth.request_token.key;
rtSecret = auth.request_token.secret;
# 　　进行到这一步针对桌面应用和网页应用有两个不同的分支：
# 　　１、桌面应用将授权页面网址提供给用户，用户访问授权页面，输入用户名和密码并通过验证之后，获取到一个授权码，回到桌面应用中提交该授权码。
# 　　２、网页应用直接将用户引导至授权页面，引导前应将rtKey和rtSecret缓存到Session中。当用户在授权页面输入用户名和密码并通过验证之后，
#     授权页面会调用网页应用的回调页面，同时传递参数oauth_token和oauth_verifier，其中oauth_token应和rtKey相同（回调页面中需确认此处），
#     而oauth_verifier即为授权码，下文中简称为verifier。
# 　　有了授权码verifier之后，加上之前缓存在Session中的rtKey和rtSecret便可获取用户令牌密钥。

#设定请求令牌密钥(桌面应用跳过此句)
auth.set_request_token( rtKey, rtSecret );

#获取用户令牌密钥.
access_token = auth.get_access_token( verifier );
atKey = access_token.key;
atSecret = access_token.secret;
# 　　终于，我们获取到了用户令牌密钥atKey和atSecret，接下来的所有步骤都需要用这两个参数来验证用户的身份。

# 三、获取用户信息
from weibopy.error import WeibopError;

#设定用户令牌密钥.
auth.setToken( atKey, atSecret );
#绑定用户验证信息.
api = API(auth);

#获取用户信息.
try:
  user = api.verify_credentials();
except WeibopError, e:
  return e.reason;  

#用户ID
userid = user.id;
#用户昵称.
username = user.screen_name.encode('utf-8');
# 四、发布微博消息
from weibopy.error import WeibopError;

#设定用户令牌密钥.
auth.setToken( atKey, atSecret );
#绑定用户验证信息.
api = API(auth);

#如果不传送图片.
if ( ImagePath == None ):
  #发布普通微博.
  try:
    #message为微博消息，lat为纬度，long为经度.
    api.update_status( message, lat, long );
  except WeibopError, e:
    return e.reason;

#如果传送图片.
else:
  #发布图文微博.
  try:
    #ImagePath为图片在操作系统中的访问地址，其余同上.
    api.upload( ImagePath, message, lat, long );
  except WeibopError, e:
    return e.reason;
# 五、获取微博消息列表
#设定用户令牌密钥.
auth.setToken( atKey, atSecret );
#绑定用户验证信息.
api = API(auth);

WeiboList = [];
#获取微博列表.
#count为每页消息数量，page为从1开始计数的页码.
try:
  timeline = api.user_timeline( count = count, 
                                page = page );
except:
  return None;

#对微博列表中的微博信息进行逐个枚举.
for status in timeline:
  weibo = {};

  #微博id
  weibo["id"] = status.id;
  #微博创建时间.
  weibo["created"] = status.created_at;

  #微博发布用户.
  weibo["user"] = status.user.name.encode('utf-8');
  #微博文字.
  weibo["text"] = status.text.encode('utf-8');
  #微博来源.
  weibo["source"] = status.source.encode('utf-8');

  #地理信息.
  coordinates = getattr( status.geo, 
                         "coordinates", None );
  if ( coordinates ):
    #地理信息纬度.
    weibo["lat"] = coordinates[0];
    #地理信息经度.
    weibo["long"] = coordinates[1];
  else:
    weibo["lat"] = None;
    weibo["long"] = None;

  #引用微博.
  refer = getattr( status, 
                   "retweeted_status", None );
  if ( refer ):
    #引用微博发布用户.
    weibo["ruser"] = refer.user.name.encode('utf-8');
    #引用微博文字.
    weibo["rtext"] = refer.text.encode('utf-8');
  else:
    weibo["ruser"] = None;
    weibo["rtext"] = None;

  #附图原图.
  weibo["orgpic"] = getattr( status, 
                             "original_pic", None );
  #附图中型图.
  weibo["midpic"] = getattr( status, 
                             "bmiddle_pic", None );
  #附图缩略图.
  weibo["thumb"] = getattr( status, 
                            "thumbnail_pic", None );

  WeiboList.append( weibo );

return WeiboList;
# 六、获取单条微博消息
# 　　此处sinatpy开发包中的相关代码存在问题，调用绑定json函数时显示404错误，出于种种考虑没有直接修改api，而是在调用代码中进行了重新绑定处理。

from weibopy.binder import bind_api;

#设定用户令牌密钥.
auth.setToken( atKey, atSecret );
#绑定用户验证信息.
api = API(auth);

path = '/statuses/show/' + str(id) + '.json';
try:
  #重新绑定get_status函数
  get_status = bind_api( path = path, 
                         payload_type = 'status' );
except:
  return "**绑定错误**";

#获取微博消息.
status = get_status( api );
#以下参考获取微博消息列表中相关代码

'''
应用python编写简单新浪微博应用（二）
'''
# 一、评论微博消息
from weibopy.error import WeibopError;

#设定用户令牌密钥.
auth.setToken( atKey, atSecret );
#绑定用户验证信息.
api = API(auth);

#评论指定微博信息.
try:
  #id为评论的微博id，cid为回复的评论id，comment为评论内容.
  #comment_ori为是否同时评论原微博（所评论微博为转发时）
  api.comment( id = id, 
               cid = cid,
               comment = comment,
               comment_ori = comment_ori );
except WeibopError, e:
  return e.reason;

return "ok";
# 二、转发微博消息
from weibopy.error import WeibopError;

#设定用户令牌密钥.
auth.setToken( atKey, atSecret );
#绑定用户验证信息.
api = API(auth);

#转发指定微博信息.
try:
  #id为被转发的微博id，status为转发时添加的内容.
  api.repost( id = id, 
              status = status );
except WeibopError, e:
  return e.reason;

return "ok";
# 三、获取未读消息数
from weibopy.error import WeibopError;

#设定用户令牌密钥.
auth.setToken( atKey, atSecret );
#绑定用户验证信息.
api = API(auth);

#获取未读消息数.
try:
  count = api.unread(with_new_status=1);
except WeibopError, e:
  return e.reason;

unread={};
#是否有未读的微博.
unread['new_status'] = count.new_status;
#未读评论数.
unread['comments'] = count.comments;
#未读私信数.
unread['dm'] = count.dm;
#未读＠信息数
unread['mentions'] = count.mentions;
#新粉丝数.
unread['followers'] = count.followers;

return unread;
# 四、获取评论列表
from weibopy.error import WeibopError;

#设定用户令牌密钥.
auth.setToken( atKey, atSecret );
#绑定用户验证信息.
api = API(auth);

CommentList = [];
#获取指定页评论信息列表.
try:
  timeline = api.comments_timeline( count = count, 
                                    page = page );
except WeibopError, e:
  return e.reason;

#对微博信息列表进行逐条处理.
for line in timeline:
  comment = {};

  #评论id
  comment["id"] = line.id;
  #评论用户ID
  comment["uid"] = line.user.id;
  #评论用户名称
  comment["user"] = line.user.name.encode('utf-8');
  #评论文字.
  comment["text"] = line.text.encode('utf-8');
  #评论创建时间.
  comment["created"] = line.created_at;
  #评论来源.
  comment["source"] = line.source.encode('utf-8');

  #被评论的微博.
  status = getattr( line, "status", None );
  #被评论的微博ID.
  comment["wid"] = status.id;
  #被评论的微博用户ID.
  comment["wuid"] = status.user.id;

  reply = getattr( line, "reply_comment", None );
  #如果是回复评论.
  if ( reply ):
    #评论类型.
    comment["rtype"] = 1;
    #被评论的用户ID
    comment["ruid"] = reply.user['id'];
    #被评论的用户名称.
    comment["ruser"] = reply.user['name'].encode('utf-8');
    #评论内容.
    comment["rtext"] = reply.text.encode('utf-8');
  #如果不是回复评论（是直接评论微博）.
  else:
    #评论类型.
    comment["rtype"] = 0;
    #被评论的用户ID
    comment["ruid"] = status.user.id;
    #被评论的用户名称.
    comment["ruser"] = status.user.name.encode('utf-8');
    #评论内容.
    comment["rtext"] = status.text.encode('utf-8');

  CommentList.append( comment );

return CommentList;
　'''　
注意：新浪微博给出的程序包的Comments类有个小问题，需要更正后才能正常调用相关功能。
weibopy/models.py 中的如下部分
'''
class Comments(Model):

    @classmethod
    def parse(cls, api, json):
        comments = cls(api)
        for k, v in json.items():
            if k == 'user':
                user = User.parse(api, v)
                setattr(comments, 'author', user)
                setattr(comments, k, user)
            elif k == 'status':
                status = Status.parse(api, v)
                setattr(comments, 'user', status)
            elif k == 'created_at':
                setattr(comments, k, parse_datetime(v))
            elif k == 'reply_comment':
                setattr(comments, k, User.parse(api, v))
            else:
                setattr(comments, k, v)
        return comments
#　应更正为

class Comments(Model):

    @classmethod
    def parse(cls, api, json):
        comments = cls(api)
        for k, v in json.items():
            if k == 'user':
                user = User.parse(api, v)
                setattr(comments, 'author', user)
                setattr(comments, k, user)
            elif k == 'status':
                status = Status.parse(api, v)
                setattr(comments, k, status)
            elif k == 'created_at':
                setattr(comments, k, parse_datetime(v))
            elif k == 'reply_comment':
                setattr(comments, k, User.parse(api, v))
            else:
                setattr(comments, k, v)
        return comments
即可。

# 五、关注指定用户
from weibopy.error import WeibopError;

#设定用户令牌密钥.
auth.setToken( atKey, atSecret );
#绑定用户验证信息.
api = API(auth);

#关注指定用户.
try:
  api.create_friendship( user_id = user_id );
except WeibopError, e:
  return e.reason;

return "ok";
# 六、取消关注指定用户
from weibopy.error import WeibopError;

#设定用户令牌密钥.
auth.setToken( atKey, atSecret );
#绑定用户验证信息.
api = API(auth);

#取消关注指定用户.
try:
  api.destroy_friendship( user_id = user_id );
except WeibopError, e:
  return e.reason;

return "ok";
# 七、显示和指定用户的关系
from weibopy.error import WeibopError;

#设定用户令牌密钥.
auth.setToken( atKey, atSecret );
#绑定用户验证信息.
api = API(auth);

#显示和指定用户的关系.
try:
  source, target = api.show_friendship(target_id = user_id);
  if source.following:
    if source.followed_by:
      #互相关注.
      friendship = 3;
    else:
      #我关注他.
      friendship = 2;
  else:
    if source.followed_by:
      #他关注我.
      friendship = 1;
    else:
      #互无关系.
      friendship = 0;
except WeibopError, e:
  return e.reason;

return friendship;
# 八、获取指定用户信息
from weibopy.error import WeibopError;

#设定用户令牌密钥.
auth.setToken( atKey, atSecret );
#绑定用户验证信息.
api = API(auth);

#获取指定用户信息.
try:
  thisUser = {};
  result = api.get_user( user_id = user_id,
                         screen_name = screen_name );

  #用户ID
  thisUser['id'] = result.id;
  #用户名称.
  thisUser['name'] = result.name.encode('utf-8');
  #所在城市.
  thisUser['location'] = result.location.encode('utf-8');
  #自我描述.
  thisUser['description'] = result.description.encode('utf-8');
  #个人主页.
  thisUser['url'] = result.url;
  #头像图片地址.
  thisUser['profile'] = result.profile_image_url;
  #是否实名认证.
  thisUser['verified'] = result.verified;
  #粉丝数.
  thisUser['followers_count'] = result.followers_count;
  #关注数.
  thisUser['friends_count'] = result.friends_count;
  #微博数.
  thisUser['statuses_count'] = result.statuses_count;

except WeibopError, e:
  return e.reason;

return thisUser ;
'''
　　本文和上文中均为涉及到的功能，参考两文中的示例代码，结合新浪给出的API文档，再适当阅读sinatpy开发包中的相关代码，相信具有一定python基础的开发者很容易就能实现各种操作。
　　最后一点小窍门：sinatpy中只绑定了部分常用函数，对于sinatpy中未绑定的函数，可以参考新浪API给出的json地址在代码中进行自行绑定，调用自行绑定的函数时记得需将api做为第一个参数传递。
    对于Modules.py中未定义的变量类型，简单的可以借用一下tags类型，复杂的就只能自己在该脚本中添加相关类型啦。
'''
