# Ӧ��python��д������΢��Ӧ�ã�һ��
# http://beauty.hit.edu.cn/myStudy/Product/doc.2011-09-05.3305539365


'''
=============ת����ע������=============

�������ȣ���Ҫ��һ������΢���˺š�
��������ҳ�棺http://weibo.com

������Σ���Ҫ������΢���Ŀ���ƽ̨�д���һ��Ӧ�ã���ȡ�Լ�ר����App Key��App Secret��
��������ҳ�棺http://open.weibo.com/development

�����ٴΣ���Ҫ����һ��sinatpy�������������������û��setup.py���ֹ���ѹ��weibopyĿ¼������python�Ŀ�Ŀ¼�¼��ɡ�
��������ҳ�棺http://code.google.com/p/sinatpy/downloads/list
�����ر�ע�⣺�ݸ��˲��ԣ��ÿ��������֧��python2.4������Ҫͬʱ����simplejsonĿ¼��python�Ŀ�Ŀ¼�¡�

�������ˣ�һ�����������뱸����Ȼ��������������Ĵ��뷶��˵����ε��ÿ������е���Ӧ������ɻ�����Ӧ����Ȩ����ȡ�û���Ϣ������΢����Ϣ����ȡ΢����Ϣ�б���ȡָ��΢����Ϣ�Ȳ�����������ϣ����������������ϸ�Ķ�����΢������ƽ̨���ṩ�������ĵ����ر�����Ȩ����˵�����������в�����׸����ر������ϡ�
�����ĵ�ҳ�棺http://open.weibo.com/wiki
'''

# һ��Ӧ����֤��ش���
�������µĴ������ڻ������룬֮���������Ĵ������н����´��롣

from weibopy.auth import OAuthHandler
from weibopy.api import API
import webbrowser

#��Ӧ�õĿ�������Կ(�˴�Ӧ�滻Ϊ����Ӧ��ʱ��ȡ���Ŀ�����Կ)
APP_KEY = '1234567890';
APP_SECRET = 'abcdefghijklmnopqrstuvwxyz123456';

#�趨��ҳӦ�ûص�ҳ��(����Ӧ���趨�˱���Ϊ��)
BACK_URL = "http://beauty.hit.edu.cn/backurl";
#��֤��������Կ.
auth = OAuthHandler( APP_KEY, APP_SECRET, BACK_URL );
# ����Ӧ����Ȩ��ش���
#��ȡ��Ȩҳ����ַ.
auth_url = auth.get_authorization_url();
webbrowser.open(auth_url)
verifier = raw_input('PIN: ').strip() 
#ȡ������������Կ(����Ӧ�������˴�)
rtKey = auth.request_token.key;
rtSecret = auth.request_token.secret;
# �������е���һ���������Ӧ�ú���ҳӦ����������ͬ�ķ�֧��
# ������������Ӧ�ý���Ȩҳ����ַ�ṩ���û����û�������Ȩҳ�棬�����û��������벢ͨ����֤֮�󣬻�ȡ��һ����Ȩ�룬�ص�����Ӧ�����ύ����Ȩ�롣
# ����������ҳӦ��ֱ�ӽ��û���������Ȩҳ�棬����ǰӦ��rtKey��rtSecret���浽Session�С����û�����Ȩҳ�������û��������벢ͨ����֤֮��
#     ��Ȩҳ��������ҳӦ�õĻص�ҳ�棬ͬʱ���ݲ���oauth_token��oauth_verifier������oauth_tokenӦ��rtKey��ͬ���ص�ҳ������ȷ�ϴ˴�����
#     ��oauth_verifier��Ϊ��Ȩ�룬�����м��Ϊverifier��
# ����������Ȩ��verifier֮�󣬼���֮ǰ������Session�е�rtKey��rtSecret��ɻ�ȡ�û�������Կ��

#�趨����������Կ(����Ӧ�������˾�)
auth.set_request_token( rtKey, rtSecret );

#��ȡ�û�������Կ.
access_token = auth.get_access_token( verifier );
atKey = access_token.key;
atSecret = access_token.secret;
# �������ڣ����ǻ�ȡ�����û�������ԿatKey��atSecret�������������в��趼��Ҫ����������������֤�û�����ݡ�

# ������ȡ�û���Ϣ
from weibopy.error import WeibopError;

#�趨�û�������Կ.
auth.setToken( atKey, atSecret );
#���û���֤��Ϣ.
api = API(auth);

#��ȡ�û���Ϣ.
try:
  user = api.verify_credentials();
except WeibopError, e:
  return e.reason;  

#�û�ID
userid = user.id;
#�û��ǳ�.
username = user.screen_name.encode('utf-8');
# �ġ�����΢����Ϣ
from weibopy.error import WeibopError;

#�趨�û�������Կ.
auth.setToken( atKey, atSecret );
#���û���֤��Ϣ.
api = API(auth);

#���������ͼƬ.
if ( ImagePath == None ):
  #������ͨ΢��.
  try:
    #messageΪ΢����Ϣ��latΪγ�ȣ�longΪ����.
    api.update_status( message, lat, long );
  except WeibopError, e:
    return e.reason;

#�������ͼƬ.
else:
  #����ͼ��΢��.
  try:
    #ImagePathΪͼƬ�ڲ���ϵͳ�еķ��ʵ�ַ������ͬ��.
    api.upload( ImagePath, message, lat, long );
  except WeibopError, e:
    return e.reason;
# �塢��ȡ΢����Ϣ�б�
#�趨�û�������Կ.
auth.setToken( atKey, atSecret );
#���û���֤��Ϣ.
api = API(auth);

WeiboList = [];
#��ȡ΢���б�.
#countΪÿҳ��Ϣ������pageΪ��1��ʼ������ҳ��.
try:
  timeline = api.user_timeline( count = count, 
                                page = page );
except:
  return None;

#��΢���б��е�΢����Ϣ�������ö��.
for status in timeline:
  weibo = {};

  #΢��id
  weibo["id"] = status.id;
  #΢������ʱ��.
  weibo["created"] = status.created_at;

  #΢�������û�.
  weibo["user"] = status.user.name.encode('utf-8');
  #΢������.
  weibo["text"] = status.text.encode('utf-8');
  #΢����Դ.
  weibo["source"] = status.source.encode('utf-8');

  #������Ϣ.
  coordinates = getattr( status.geo, 
                         "coordinates", None );
  if ( coordinates ):
    #������Ϣγ��.
    weibo["lat"] = coordinates[0];
    #������Ϣ����.
    weibo["long"] = coordinates[1];
  else:
    weibo["lat"] = None;
    weibo["long"] = None;

  #����΢��.
  refer = getattr( status, 
                   "retweeted_status", None );
  if ( refer ):
    #����΢�������û�.
    weibo["ruser"] = refer.user.name.encode('utf-8');
    #����΢������.
    weibo["rtext"] = refer.text.encode('utf-8');
  else:
    weibo["ruser"] = None;
    weibo["rtext"] = None;

  #��ͼԭͼ.
  weibo["orgpic"] = getattr( status, 
                             "original_pic", None );
  #��ͼ����ͼ.
  weibo["midpic"] = getattr( status, 
                             "bmiddle_pic", None );
  #��ͼ����ͼ.
  weibo["thumb"] = getattr( status, 
                            "thumbnail_pic", None );

  WeiboList.append( weibo );

return WeiboList;
# ������ȡ����΢����Ϣ
# �����˴�sinatpy�������е���ش���������⣬���ð�json����ʱ��ʾ404���󣬳������ֿ���û��ֱ���޸�api�������ڵ��ô����н��������°󶨴���

from weibopy.binder import bind_api;

#�趨�û�������Կ.
auth.setToken( atKey, atSecret );
#���û���֤��Ϣ.
api = API(auth);

path = '/statuses/show/' + str(id) + '.json';
try:
  #���°�get_status����
  get_status = bind_api( path = path, 
                         payload_type = 'status' );
except:
  return "**�󶨴���**";

#��ȡ΢����Ϣ.
status = get_status( api );
#���²ο���ȡ΢����Ϣ�б�����ش���

'''
Ӧ��python��д������΢��Ӧ�ã�����
'''
# һ������΢����Ϣ
from weibopy.error import WeibopError;

#�趨�û�������Կ.
auth.setToken( atKey, atSecret );
#���û���֤��Ϣ.
api = API(auth);

#����ָ��΢����Ϣ.
try:
  #idΪ���۵�΢��id��cidΪ�ظ�������id��commentΪ��������.
  #comment_oriΪ�Ƿ�ͬʱ����ԭ΢����������΢��Ϊת��ʱ��
  api.comment( id = id, 
               cid = cid,
               comment = comment,
               comment_ori = comment_ori );
except WeibopError, e:
  return e.reason;

return "ok";
# ����ת��΢����Ϣ
from weibopy.error import WeibopError;

#�趨�û�������Կ.
auth.setToken( atKey, atSecret );
#���û���֤��Ϣ.
api = API(auth);

#ת��ָ��΢����Ϣ.
try:
  #idΪ��ת����΢��id��statusΪת��ʱ��ӵ�����.
  api.repost( id = id, 
              status = status );
except WeibopError, e:
  return e.reason;

return "ok";
# ������ȡδ����Ϣ��
from weibopy.error import WeibopError;

#�趨�û�������Կ.
auth.setToken( atKey, atSecret );
#���û���֤��Ϣ.
api = API(auth);

#��ȡδ����Ϣ��.
try:
  count = api.unread(with_new_status=1);
except WeibopError, e:
  return e.reason;

unread={};
#�Ƿ���δ����΢��.
unread['new_status'] = count.new_status;
#δ��������.
unread['comments'] = count.comments;
#δ��˽����.
unread['dm'] = count.dm;
#δ������Ϣ��
unread['mentions'] = count.mentions;
#�·�˿��.
unread['followers'] = count.followers;

return unread;
# �ġ���ȡ�����б�
from weibopy.error import WeibopError;

#�趨�û�������Կ.
auth.setToken( atKey, atSecret );
#���û���֤��Ϣ.
api = API(auth);

CommentList = [];
#��ȡָ��ҳ������Ϣ�б�.
try:
  timeline = api.comments_timeline( count = count, 
                                    page = page );
except WeibopError, e:
  return e.reason;

#��΢����Ϣ�б������������.
for line in timeline:
  comment = {};

  #����id
  comment["id"] = line.id;
  #�����û�ID
  comment["uid"] = line.user.id;
  #�����û�����
  comment["user"] = line.user.name.encode('utf-8');
  #��������.
  comment["text"] = line.text.encode('utf-8');
  #���۴���ʱ��.
  comment["created"] = line.created_at;
  #������Դ.
  comment["source"] = line.source.encode('utf-8');

  #�����۵�΢��.
  status = getattr( line, "status", None );
  #�����۵�΢��ID.
  comment["wid"] = status.id;
  #�����۵�΢���û�ID.
  comment["wuid"] = status.user.id;

  reply = getattr( line, "reply_comment", None );
  #����ǻظ�����.
  if ( reply ):
    #��������.
    comment["rtype"] = 1;
    #�����۵��û�ID
    comment["ruid"] = reply.user['id'];
    #�����۵��û�����.
    comment["ruser"] = reply.user['name'].encode('utf-8');
    #��������.
    comment["rtext"] = reply.text.encode('utf-8');
  #������ǻظ����ۣ���ֱ������΢����.
  else:
    #��������.
    comment["rtype"] = 0;
    #�����۵��û�ID
    comment["ruid"] = status.user.id;
    #�����۵��û�����.
    comment["ruser"] = status.user.name.encode('utf-8');
    #��������.
    comment["rtext"] = status.text.encode('utf-8');

  CommentList.append( comment );

return CommentList;
��'''��
ע�⣺����΢�������ĳ������Comments���и�С���⣬��Ҫ�������������������ع��ܡ�
weibopy/models.py �е����²���
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
#��Ӧ����Ϊ

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
���ɡ�

# �塢��עָ���û�
from weibopy.error import WeibopError;

#�趨�û�������Կ.
auth.setToken( atKey, atSecret );
#���û���֤��Ϣ.
api = API(auth);

#��עָ���û�.
try:
  api.create_friendship( user_id = user_id );
except WeibopError, e:
  return e.reason;

return "ok";
# ����ȡ����עָ���û�
from weibopy.error import WeibopError;

#�趨�û�������Կ.
auth.setToken( atKey, atSecret );
#���û���֤��Ϣ.
api = API(auth);

#ȡ����עָ���û�.
try:
  api.destroy_friendship( user_id = user_id );
except WeibopError, e:
  return e.reason;

return "ok";
# �ߡ���ʾ��ָ���û��Ĺ�ϵ
from weibopy.error import WeibopError;

#�趨�û�������Կ.
auth.setToken( atKey, atSecret );
#���û���֤��Ϣ.
api = API(auth);

#��ʾ��ָ���û��Ĺ�ϵ.
try:
  source, target = api.show_friendship(target_id = user_id);
  if source.following:
    if source.followed_by:
      #�����ע.
      friendship = 3;
    else:
      #�ҹ�ע��.
      friendship = 2;
  else:
    if source.followed_by:
      #����ע��.
      friendship = 1;
    else:
      #���޹�ϵ.
      friendship = 0;
except WeibopError, e:
  return e.reason;

return friendship;
# �ˡ���ȡָ���û���Ϣ
from weibopy.error import WeibopError;

#�趨�û�������Կ.
auth.setToken( atKey, atSecret );
#���û���֤��Ϣ.
api = API(auth);

#��ȡָ���û���Ϣ.
try:
  thisUser = {};
  result = api.get_user( user_id = user_id,
                         screen_name = screen_name );

  #�û�ID
  thisUser['id'] = result.id;
  #�û�����.
  thisUser['name'] = result.name.encode('utf-8');
  #���ڳ���.
  thisUser['location'] = result.location.encode('utf-8');
  #��������.
  thisUser['description'] = result.description.encode('utf-8');
  #������ҳ.
  thisUser['url'] = result.url;
  #ͷ��ͼƬ��ַ.
  thisUser['profile'] = result.profile_image_url;
  #�Ƿ�ʵ����֤.
  thisUser['verified'] = result.verified;
  #��˿��.
  thisUser['followers_count'] = result.followers_count;
  #��ע��.
  thisUser['friends_count'] = result.friends_count;
  #΢����.
  thisUser['statuses_count'] = result.statuses_count;

except WeibopError, e:
  return e.reason;

return thisUser ;
'''
�������ĺ������о�Ϊ�漰���Ĺ��ܣ��ο������е�ʾ�����룬������˸�����API�ĵ������ʵ��Ķ�sinatpy�������е���ش��룬���ž���һ��python�����Ŀ����ߺ����׾���ʵ�ָ��ֲ�����
�������һ��С���ţ�sinatpy��ֻ���˲��ֳ��ú���������sinatpy��δ�󶨵ĺ��������Բο�����API������json��ַ�ڴ����н������а󶨣��������а󶨵ĺ���ʱ�ǵ��轫api��Ϊ��һ���������ݡ�
    ����Modules.py��δ����ı������ͣ��򵥵Ŀ��Խ���һ��tags���ͣ����ӵľ�ֻ���Լ��ڸýű�����������������
'''
