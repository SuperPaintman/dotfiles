#!/usr/bin/python
import os
import re

root = os.path.dirname(os.path.abspath(__file__))
root_dir = os.path.abspath(os.path.join(root, ".."))

os.chdir(root_dir)

bundles_dir = os.path.expanduser("~/.vim/bundle/")
for d in os.listdir(bundles_dir):
    if os.path.isfile(os.path.join(bundles_dir, d)):
        continue

    bundle_dir = os.path.abspath(os.path.join(bundles_dir, d))

    repo_url = os.popen("cd %s && git remote get-url origin" % bundle_dir).read()
    repo_url = repo_url.replace("\n", "") 

    result = re.match(r"^(?:.*)github\.com\/(?P<username>[^\/]+)\/(?P<reponame>[^\/\.]+)(?:\.git)?$", repo_url)
    [username, reponame] = [result.group("username"), result.group("reponame")]

    os.system("git submodule add git@github.com:%s/%s.git ./.vim/bundle/%s" % (username, reponame, reponame))
