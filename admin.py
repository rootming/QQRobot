#! /usr/bin/python


class User:
    def __init__(self, uid, level):
        self.uid = uid
        self.level = level


class Command:
    def __init__(self, cmd, cmdname, level):
        self.cmd = cmd
        self.cmdname = cmdname
        self.level = level

# TODO: let name be list, not single user


class Management:
    def __init__(self):
        self.cmdList = []
        self.userList = []
        self.admin = None

    def addcmd(self, cmd, cmdname, level):
        self.cmdList.append(Command(cmd, cmdname, level))

    def listcmd(self):
        for it in self.cmdList:
            print "Level: %d, username: %s, command name: %s" % (it.level, it.name, it.cmdname)

    def findcmd(self, cmdname):
        for it in self.cmdList:
            if it.cmdname == cmdname:
                return it
        return None

    def getcmd(self, cmdname, user):
        cmd = self.findcmd(cmdname)
        if cmd is None:
            print 'Command not found'
            return None
        else:
            if cmd.level <= user.level:
                return cmd.cmd
            else:
                print "No permission!"
                print "cmd.level %d, user.level %d" % (cmd.level, user.level)
            return None

    def setadmin(self, uid):
        self.admin = User(uid, 10)
        self.userList.append(self.admin)

    def getuser(self, uid):
        for it in self.userList:
            if it.uid == str(uid):
                return it
        return None


# manage = Management()
# manage.setadmin('3789275917')
# manage.addcmd(lambda x, y: x + y, "add", 1, 'rootming')
# manage.listcmd()
# my = manage.getcmd("add", User("3789275917", 1))
# print my(1, 2)
