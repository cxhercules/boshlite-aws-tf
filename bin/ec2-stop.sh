#!/bin/bash

aws ec2 stop-instances --instance-ids $(terraform output boshlite_ec2_id)

