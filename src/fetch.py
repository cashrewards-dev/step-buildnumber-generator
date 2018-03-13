#!/usr/bin/env python

from optparse import OptionParser
import urllib
import urllib2
import sys
import json

parser = OptionParser()

parser.add_option("-U", "--url", type="string", dest="url")
parser.add_option("-u", "--user", type="string", dest="username")
parser.add_option("-k", "--key", type="string", dest="key")
parser.add_option("-a", "--appId", type="string", dest="app")
parser.add_option("-b", "--branch", type="string", dest="branch")
parser.add_option("-c", "--commit", type="string", dest="commit")

(options, args) = parser.parse_args()

if options.url.endswith("/") is False:
    options.url += "/"

if options.username is None :
    options.username = 'werckerbot'

url = "{url}{app}".format(url=options.url, app=options.app)

headers = {'x-api-key': options.key}
values = {
    'username': options.username,

}

if options.branch :
    values['branch'] = options.branch

if options.commit :
    values['commit_hash'] = options.commit  

#data = urllib.urlencode(values)
data = json.dumps(values)

try:
    req = urllib2.Request(url, data, headers)
    res = urllib2.urlopen(req)

    status_code = res.getcode()
    res_body = res.read()

except urllib2.HTTPError as e:
    status_code = e.code

except urllib2.URLError as e:
    sys.exit("""Error: Failed to reach server.
Reason: {reason}""".format(reason=e.reason))

if status_code == -1:
    sys.exit("Unable to connect to {url}".format(url=url))
elif status_code != 200:
    sys.exit(
        """Server couldn't fulfill the request.
url: {url}
status code: {code}""".format(
        url=url,
        code=status_code
    ))
else:
    data = json.loads(res_body)
    #print(json.dumps(data))
    build_number = data.get("buildnumber")
    if build_number :
        print build_number
    else:
        sys.exit("Unexpected return data: " + data)

