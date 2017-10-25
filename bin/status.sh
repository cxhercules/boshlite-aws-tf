#!/bin/bash

aws ec2 describe-instance-status --instance-ids $(terraform output boshlite_ec2_id)
