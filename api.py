#!/usr/bin/env python
#  coding=utf-8
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2022-06-28 15:13:25 +0100 (Tue, 28 Jun 2022)
#
#  https://github.com/HariSekhon/templates
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn
#  and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/HariSekhon
#

#   pip install fastapi "uvicorn[standard]"
#
#       uvicorn <filename>:<fastapi_app>
#
#  run: uvicorn api:app --reload
#
#  http://127.0.0.1:8000

"""

FastAPI Starter App

https://fastapi.tiangolo.com/

https://github.com/tiangolo/fastapi

"""

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

#import logging
#import os
#import re
#import sys
#import time
#import traceback
# from typing import Union
from fastapi import FastAPI

__author__ = 'Hari Sekhon'
__version__ = '0.1'

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}


# @app.get("/items/{item_id}")
# def read_item(item_id: int, q: Union[str, None] = None):
#     return {"item_id": item_id, "q": q}
