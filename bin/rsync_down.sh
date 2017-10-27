#!/bin/bash

rsync -avz ubuntu@$(terraform output boshlite_ip):~/* workspace/
