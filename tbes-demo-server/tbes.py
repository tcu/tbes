#
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

#* ---------------------------------------------------------------------------
#** Texas Christian University
#**
#** main.m
#** TBES
#**
#** Created on 12/4/12
#** Danny Westfall
#** 
#** -------------------------------------------------------------------------*/


import os
import sys
import time
import random
from twisted.protocols import basic
from twisted.internet.protocol import Protocol, Factory
from twisted.internet import reactor, defer, threads
from twisted.application import service, internet
from twisted.internet.task import deferLater
from twisted.protocols.basic import NetstringReceiver
from twisted.protocols.basic import LineReceiver

messages = ['0,1,0,0,0,0',
'0,0,0,0,0,0',
'0,3,0,0,0,0',
'0,0,0,0,0,0',
'0,3,0,0,0,0',
'0,0,0,0,0,0',
'0,1,0,0,0,0',
'0,0,0,0,0,0',
'0,1,0,0,0,0',
'0,0,0,0,0,0',
'0,6,0,0,0,0',
'0,0,0,0,0,0',
'0,2,0,0,0,0',
'0,0,0,0,0,0',
'0,4,0,0,0,0',
'0,0,0,0,0,0',
'0,1,0,0,0,0',
'0,0,0,0,0,0',
'0,6,0,0,0,0',
'0,0,0,0,0,0',
'0,2,0,0,0,0',
'0,0,0,0,0,0',
'0,2,0,0,0,0',
'0,0,0,0,0,0',
'0,1,0,0,0,0',
'0,0,0,0,0,0',
'0,4,0,0,0,0',
'0,0,0,0,0,0',
'0,6,0,0,0,0',
'0,0,0,0,0,0',
'0,3,0,0,0,0',
'0,0,0,0,0,0',
'0,4,0,0,0,0',
'0,0,0,0,0,0',
'0,6,0,0,0,0',
'0,0,0,0,0,0',
'0,1,0,0,0,0',
'0,0,0,0,0,0',
'0,1,0,0,0,0',
'0,0,0,0,0,0',
'0,2,0,0,0,0',
'0,0,0,0,0,0',
'0,3,0,0,0,0',
'0,0,0,0,0,0',
'0,6,0,0,0,0',
'0,0,0,0,0,0',
'0,6,0,0,0,0',
'0,0,0,0,0,0',
'0,4,0,0,0,0',
'0,0,0,0,0,0',
'0,2,0,0,0,0',
'0,0,0,0,0,0',
'0,1,0,0,0,0']


connectedClients = 0

class MyChat(LineReceiver):
   
    def __init__(self):
        self.messageIndex = 0
        self.clientIndex = 0
	self.connected = True

    def connectionMade(self):
        print "Got new client!"
        global connectedClients
        connectedClients = connectedClients + 1
        self.clientIndex = connectedClients
        #time.sleep(1)
        self.sendLine('0,0,0,0,0,0')
        
        d = threads.deferToThread(self.getNextMessage)
        d.addCallback(self.reply)
        

    def getNextMessage(self):
      time.sleep(5)
      self.messageIndex = self.messageIndex + 1      
      num_messages = len(messages)
      if self.messageIndex > (num_messages - 1):
        self.messageIndex = 0
      return messages[self.messageIndex]
      
    def connectionLost(self, reason):
        self.connected = False
        
        print "Lost a client!"

    def reply(self, response):

        if self.connected:
          print 'Client %d: %s' % (self.clientIndex, response)
          d = threads.deferToThread(self.getNextMessage)
          d.addCallback(self.reply)
          self.sendLine(response)
        else:
          print 'Client %d: Disconnected' % self.clientIndex

    def lineReceived(self, line):
        print "received", repr(line)


def main():
    f = Factory()
    f.protocol = MyChat
    f.messageIndex = 0
    reactor.listenTCP(8080, f)
    reactor.run()

if __name__ == '__main__':
    main()

