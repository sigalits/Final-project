Role Name :Consul 
=========

This playbook deploys consul server or agent with Nginx Docker Containers .

Requirements
------------

The role uses the EC2 module to Deploy servers with tag consul_agent/consul_server*.



Example Playbook
----------------

- name: confugire consul 
   hosts: consul_server consul_agent

  
   roles:
    - consul


Author Information
------------------

Author: Sigalit Hillel Shelly 
Email : sigalit.hillel@gmail.com
