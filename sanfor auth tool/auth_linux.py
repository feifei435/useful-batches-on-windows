#coding: utf-8
__author__ = 'feifei435'
import urllib
import urllib2
from urllib2 import Request, urlopen, URLError, HTTPError, HTTPPasswordMgr
import re
import BaseHTTPServer

#print BaseHTTPServer.BaseHTTPRequestHandler.responses

user_agent = 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)'
#user_agent = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) \
#Chrome/37.0.2062.124 Safari/537.36'
#headers = { 'User-Agent' : user_agent }

login_url = 'http://192.168.255.66/login'
logout_url = 'http://192.168.255.66/logout'

class SmartRedirectHandler(urllib2.HTTPRedirectHandler):
    def http_error_301(self, req, fp, code, msg, headers):
        print "301"
        result = urllib2.HTTPRedirectHandler.http_error_301(
            self, req, fp, code, msg, headers)
        result.status = code
        pass
        #return result

    def http_error_302(self, req, fp, code, msg, headers):
        print "302"
        result = urllib2.HTTPRedirectHandler.http_error_302(
            self, req, fp, code, msg, headers)
        result.status = code
        pass
        #return result

def login(name):
    req = urllib2.Request(login_url)                  #构造Request对象
    req.add_header('User-Agent', user_agent)
    req.add_header('AllowAutoRedirect', 'false')
    # create a password manager
    password_mgr = urllib2.HTTPPasswordMgrWithDefaultRealm()
    # Add the username and password.
    # If we knew the realm, we could use it instead of ``None``.
    #password_mgr.add_password(None, login_url, 'myname', '2011')
    password_mgr.add_password('WebAuthorizeCenter', login_url, name, '2011')

    handler = urllib2.HTTPBasicAuthHandler(password_mgr)

    # create "opener" (OpenerDirector instance)
    opener = urllib2.build_opener(handler, SmartRedirectHandler) # 添加多个handler
    #opener.add_handler(SmartRedirectHandler())

    # use the opener to fetch a URL
    #opener.open(top_level_url)

    # Install the opener.
    # Now all calls to urllib2.urlopen use our opener.
    urllib2.install_opener(opener)
    return req

def logout():
    req = urllib2.Request(logout_url)
    return req

    #print "len(ret_html) =",len(ret_html)
    #ret_html_decode = ret_html.decode("UTF-8")
    #print "len(ret_html_decode) =" ,len(ret_html_decode)

def do_action(func, param=''):
    print '*' * 13 + 'begin auth' + '*' * 13

    try:
        if param == '':
            response = urllib2.urlopen(func())
        else:
            response = urllib2.urlopen(func(param))
        print 'response URL:' + response.geturl()
        #The except HTTPError must come first, otherwise except URLError will also catch an HTTPError.
    except HTTPError, e:
        print 'The server couldn\'t fulfill the request.'
        print 'Error code:', e.code
        print 'Reason:', e.reason
        print 'Info:', e.info()
        return e.code
        #print 'Read:', e.read()
    except URLError, e:
        print e.code
        print e.reason
        print e.read()
    else:
        print '*' * 13 + 'action ok.'.decode("UTF-8") + '*' * 13
        print '*' * 13 + 'HTTP Info:' + '*' * 13 + '\r\n', response.info()
        print 'URL:', response.geturl()
        print 'CODE:', response.getcode()
        ret_html = response.read()
        #ret_html_decode = ret_html.decode("UTF-8", 'ignore')
        #ret_html_decode = ret_html.decode("UTF-8", 'ignore').encode("GB18030")
        #print ret_html_decode

        print '*' * 13 + ' content: ' + '*' * 13
        return ret_html

if __name__ == '__main__':

    namelist = ['廖江']
#    with open('namelist2.txt', 'r') as f:
#        for line in f:
#            namelist.append(line[:-1])

    for name in namelist:
        print 'trying name:' + name.decode("UTF-8", 'ignore')
        #print 'trying name' + name.decode("UTF-8", 'ignore').encode("GB18030") + '...'

        print do_action(logout)
        ret_html = do_action(login, name)
        print ret_html

        #print ret_html.find('请先注销') #用户已登陆
        #print ret_html.find('被冻结')   #密码错误

    #('<li><a href="([^"]+?)">([^<>]+?)</a></li>', complexHtml)
    #liTupleList = re.findall('', ret_html)
    #if ret_html.find