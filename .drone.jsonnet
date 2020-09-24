local pipeline = import 'pipeline.libsonnet';
local name = 'drone-covergates';

[
  pipeline.build(name, 'linux', 'amd64'),
  pipeline.build(name, 'linux', 'arm'),
  pipeline.build(name, 'linux', 'arm64'),
  pipeline.notifications(depends_on=[
    'linux-amd64',
    'linux-arm',
    'linux-arm64'
  ]),
]
