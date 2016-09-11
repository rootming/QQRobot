#!/usr/bin/python
# -*- coding: utf-8 -*-

from qqbot import QQBot
from admin import Management
from admin import User
import re
import base64

base64Pattern = re.compile(r'[a-zA-Z0-9+/]+')


def codecheck(pattern, text):
    match = pattern.match(text)
    if match is None:
        return False
    else:
        return True


def decodebase64(text):
    return base64.decodestring(text)


def encodebase64(text):
    return base64.encodestring(text)


class MyQQBot(QQBot):
    def __init__(self):
        self.manage = Management()
        self.manage.setadmin("3789275917")
        self.manage.addcmd(self.cmd_stop_robot, "-stop", 10)
        self.manage.addcmd(self.cmd_list, "-list", 10)
        print "Init MyQQBot"

    def cmd_stop_robot(self, msgType, from_uin, message):
        self.stopped = True
        self.send(msgType, from_uin, 'QQ机器人已关闭')

    def cmd_list(self, msgType, from_uin, message):
        reply = getattr(self, message[6:].strip() + 'Str', '')
        self.send(msgType, from_uin, reply)

    def onPollComplete(self, msgType, from_uin, buddy_uin, message):
        print "from_uid %s, buddy_uin %s" % (from_uin, buddy_uin)
        if str(buddy_uin) == "2147864741":
            print "Message from Piao"
            reply = "嫖虫傲娇得说道:" + message
            self.send(msgType, from_uin, reply)

        if str(buddy_uin) == "388656225":
            print "Message from BB"
            #reply = "博哥傲娇得说道:" + message
            #self.send(msgType, from_uin, reply)

        if str(buddy_uin) == "3789275917":
            print "Message from admin"

        if from_uin == buddy_uin and message[0:1] == '-':
            arg = message.split(' ', 1)
            user = self.manage.getuser(buddy_uin)
            if user is None:
                user = User(buddy_uin, 0)
            cmd = self.manage.getcmd(arg[0], user)
            cmd(msgType, from_uin, message)
        else:
            if message[-2:] == '==':
                if codecheck(base64Pattern, message):
                    reply = 'Base64 decode result: ' + decodebase64(message)
                    self.send(msgType, from_uin, reply)
            elif message[:13] == 'encodeBase64:':
                reply = 'Base64 encode result: ' + encodebase64(message[13:])
                self.send(msgType, from_uin, reply)


robot = MyQQBot()
robot.Login()
robot.Run()
