#!/usr/bin/python
# -*- coding: utf-8 -*-

from qqbot import QQBot
import re
import base64

base64Pattern = re.compile(r'[a-zA-Z0-9+/]+')


def codeCheck(pattern, text):
    match = pattern.match(text)
    if match == None:
        return False
    else:
        return True

def decodeBase64(text):
    return  base64.decodestring(text)

def encodeBase64(text):
    return base64.encodestring(text)
    
    

class MyQQBot(QQBot):
    def onPollComplete(self, msgType, from_uin, buddy_uin, message):
        
        if message == '-hello':
            self.send(msgType, from_uin, '你好，我是QQ机器人')
        elif message == '-stop':
            self.stopped = True
            self.send(msgType, from_uin, 'QQ机器人已关闭')
        elif message[-2:] == '==':
            if codeCheck(base64Pattern, message):
                reply = 'Base64 decode result: ' + decodeBase64(message)
                self.send(msgType, from_uin, reply)
        elif message[:13] == 'encodeBase64:':
            reply = 'Base64 encode result: ' + encodeBase64(message[13:])
            self.send(msgType, from_uin, reply)

myqqbot = MyQQBot()
myqqbot.Login()
myqqbot.Run()
