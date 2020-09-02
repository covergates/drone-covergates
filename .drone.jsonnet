local pipeline = import 'pipeline.libsonnet';
local name = 'drone-covergates';

[
  pipeline.build(name, 'linux', 'amd64'),
  pipeline.notifications(depends_on=[
    'linux-amd64',
  ]),
]
