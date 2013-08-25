
# Copyright 2009-2010 Joshua Roesslein
# See LICENSE for details.

from urllib import request
import base64

from weibopy import oauth
from weibopy.error import WeibopError
from weibopy.api import API


class AuthHandler(object):

    def apply_auth(self, url, method, headers, parameters):
        """Apply authentication headers to request"""
        raise NotImplementedError

    def get_username(self):
        """Return the username of the authenticated user"""
        raise NotImplementedError


class BasicAuthHandler(AuthHandler):

    def __init__(self, username, password):
        self.username = username
        keys = '%s:%s' % (username, password)
        by = keys.encode('utf-8')
        self._b64up = base64.b64encode(by)

    def apply_auth(self, url, method, headers, parameters):
        headers['Authorization'] = 'Basic %s' % self._b64up.decode('utf-8')
        
    def get_username(self):
        return self.username


class OAuthHandler(AuthHandler):
    """OAuth authentication handler"""

    OAUTH_HOST = 'api.t.sina.com.cn'
    OAUTH_ROOT = '/oauth/'

    def __init__(self, consumer_key, consumer_secret, callback=None, secure=False):
        self._consumer = oauth.OAuthConsumer(consumer_key, consumer_secret)
        self._sigmethod = oauth.OAuthSignatureMethod_HMAC_SHA1()
        self.request_token = None
        self.access_token = None
        self.callback = callback
        self.username = None
        self.secure = secure

    def _get_oauth_url(self, endpoint):
        if self.secure:
            prefix = 'https://'
        else:
            prefix = 'http://'

        return prefix + self.OAUTH_HOST + self.OAUTH_ROOT + endpoint

    def apply_auth(self, url, method, headers, parameters):
        request = oauth.OAuthRequest.from_consumer_and_token(
            self._consumer, http_url=url, http_method=method,
            token=self.access_token, parameters=parameters
        )
        request.sign_request(self._sigmethod, self._consumer, self.access_token)
        headers.update(request.to_header())

    def _get_request_token(self):
        try:
            url = self._get_oauth_url('request_token')
            requestAuth = oauth.OAuthRequest.from_consumer_and_token(
                self._consumer, http_url=url, callback=self.callback
            )
            requestAuth.sign_request(self._sigmethod, self._consumer, None)
            resp = request.urlopen(request.Request(url, headers=requestAuth.to_header()))
            return oauth.OAuthToken.from_string((resp.read().decode('UTF-8')))
        except Exception as e:
            raise WeibopError(e)

    def set_request_token(self, key, secret):
        self.request_token = oauth.OAuthToken(key, secret)

    def set_access_token(self, key, secret):
        self.access_token = oauth.OAuthToken(key, secret)

    def get_authorization_url(self, signin_with_twitter=False):
        """Get the authorization URL to redirect the user"""
        try:
            # get the requestAuth token
            self.request_token = self._get_request_token()

            # build auth requestAuth and return as url
            if signin_with_twitter:
                url = self._get_oauth_url('authenticate')
            else:
                url = self._get_oauth_url('authorize')
            requestAuth = oauth.OAuthRequest.from_token_and_callback(
                token=self.request_token, http_url=url
            )

            return requestAuth.to_url()
        except Exception as e:
            raise WeibopError(e)

    def get_access_token(self, verifier=None):
        """
        After user has authorized the requestAuth token, get access token
        with user supplied verifier.
        """
        try:
            url = self._get_oauth_url('access_token')

            # build requestAuth
            requestAuth = oauth.OAuthRequest.from_consumer_and_token(
                self._consumer,
                token=self.request_token, http_url=url,
                verifier=str(verifier)
            )
            requestAuth.sign_request(self._sigmethod, self._consumer, self.request_token)

            # send requestAuth                        
            resp = request.urlopen(request.Request(url, headers=requestAuth.to_header()))
            self.access_token = oauth.OAuthToken.from_string((resp.read()).decode('UTF-8'))
            
            print('Access token key: '+ str(self.access_token.key))
            print('Access token secret: '+ str(self.access_token.secret))
            
            return self.access_token
        except Exception as e:
            raise WeibopError(e)
        
    def setAccessToken(self, key, secret):
        self.access_token = oauth.OAuthToken(key, secret)
        
    def get_username(self):
        if self.username is None:
            api = API(self)
            user = api.verify_credentials()
            if user:
                self.username = user.screen_name
            else:
                raise WeibopError("Unable to get username, invalid oauth token!")
        return self.username

