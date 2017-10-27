#!/bin/bash

rsync -avz workspace/* ubuntu@$(terraform output boshlite_ip):~/
