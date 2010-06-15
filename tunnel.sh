#!/bin/sh

ssh -g -i ~randy/.ssh/passwordless_rsa -R 31179:localhost:22 rsontech.net -l randy -n -N
