#!/bin/bash

aws ec2 start-instances --instance-ids $(terraform output boshlite_ec2_id)

