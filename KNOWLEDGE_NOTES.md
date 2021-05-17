- NAT gateway (not just internet gateway) is needed for ECS tasks to be able to pull images from ECR.
Without it there were errors:

  ResourceInitializationError: unable to pull secrets or registry auth: pull command failed: : signal: killed

Also, `WaterstreamTaskSecurityGroup` needs egress to `0.0.0.0/0`, not just the VPC subnet. Otherwise, 
it returns the same error.

