from sys import version_info
import threading, subprocess, signal, os, platform, getpass

if version_info[0] == 3:
    import queue as Queue
else:
    import Queue

try:
  import vim
except ImportError:
  class Vim:
    def command(self, x):
      print("Executing vim command: " + x)
  
  vim = Vim()

class NimThread(threading.Thread):
  def __init__(self, project_path):
    super(NimThread, self).__init__()
    self.tasks = Queue.Queue()
    self.responses = Queue.Queue()
    self.nim = subprocess.Popen(
       ["nim", "serve", "--server.type:stdin", project_path],
       cwd = os.path.dirname(project_path),
       stdin = subprocess.PIPE,
       stdout = subprocess.PIPE,
       stderr = subprocess.STDOUT,
       universal_newlines = True,
       bufsize = 1)
 
  def postNimCmd(self, msg, async_ = True):
    self.tasks.put((msg, async_))
    if not async_:
      return self.responses.get()

  def run(self):
    while True:
      (msg, async_) = self.tasks.get()

      if msg == "quit":
        self.nim.terminate()
        break

      self.nim.stdin.write(msg + "\n")
      result = ""
      
      while True:
        line = self.nim.stdout.readline()
        result += line
        if line == "\n":
          if not async_:
            self.responses.put(result)
          else:
            self.asyncOpComplete(msg, result)
          break
        

def nimVimEscape(expr):
  return expr.replace("\\", "\\\\").replace('"', "\\\"").replace("\n", "\\n")

class NimVimThread(NimThread):
  def asyncOpComplete(self, msg, result):
    cmd = "/usr/local/bin/mvim --remote-expr 'NimAsyncCmdComplete(1, \"" + nimVimEscape(result) + "\")'"
    os.system (cmd)

NimProjects = {}

def nimStartService(project):
  target = NimVimThread(project)
  NimProjects[project] = target
  target.start()
  return target

def nimTerminateService(project):
  if NimProjects.has_key(project):
    NimProjects[project].postNimCmd("quit")
    del NimProjects[project]

def nimRestartService(project):
  nimTerminateService(project)
  nimStartService(project)

def nimExecCmd(project, cmd, async_ = True):
  target = None
  if NimProjects.has_key(project):
    target = NimProjects[project]
  else:
    target = nimStartService(project)
  
  result = target.postNimCmd(cmd, async_)
  
  if not async_:
    vim.command('let l:py_res = "' + nimVimEscape(result) + '"')

def nimTerminateAll():
  for thread in NimProjects.values():
    thread.postNimCmd("quit")
    
