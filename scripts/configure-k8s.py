#!/usr/bin/env python

import os
import sys
from jinja2 import Template

#export OM_HOST=http://localhost:8080
#export OM_USER=admin
#export OM_PASSWORD=admin12345%
#export OM_API_KEY=1dcf1b5a-a35b-454f-851d-62cf47ee266c


parameters = {}
keys = [ "OM_HOST", "OM_USER", "OM_PASSWORD", "OM_API_KEY" ]
for key in keys:
  parameters[key]=os.environ[key]

if sys.argv[1]:
  template_file=sys.argv[1]
else :
  path="/etc/mongodb/mms/env/.ops-manager-env"
  template_file="%s/k8s_config_template.yaml" % path

with open(template_file, 'r') as t:
  template = t.read()
  t = Template( template )
  rendered_template = t.render(parameters)
  print(rendered_template)



