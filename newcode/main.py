#!/usr/bin/env python3
# -*- coding: utf-8 -*-

__author__='Jay Gao 1219'

from fontend import tap
from backend import selector1,data,status

import _thread

if __name__=='__main__':
    data=data.Data()
    statue=status.Status()
    _thread.start_new_thread(selector1.run,(data,status))
    font=tap.board(data,status)
    _thread.exit()
