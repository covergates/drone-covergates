{
  build(name, os='linux', arch='amd64'):: {
    kind: 'pipeline',
    name: os + '-' + arch,
    platform: {
      os: os,
      arch: arch,
    },
    steps: [
      {
        name: 'build-push',
        image: 'golang:1.14',
        pull: 'always',
        environment: {
          CGO_ENABLED: '0',
        },
        commands: [
          'go build -v -a -o release/' + os + '/' + arch + '/' + name,
        ],
        when: {
          event: {
            exclude: [ 'tag' ],
          },
        },
      },
      {
        name: 'build-tag',
        image: 'golang:1.14',
        pull: 'always',
        environment: {
          CGO_ENABLED: '0',
        },
        commands: [
          'go build -v -ldflags \'-X main.Version=${DRONE_TAG##v}\' -a -o release/' + os + '/' + arch + '/' + name,
        ],
        when: {
          event: [ 'tag' ],
        },
      },
      {
        name: 'dryrun',
        image: 'plugins/docker:' + os + '-' + arch,
        pull: 'always',
        settings: {
          daemon_off: false,
          dry_run: true,
          tags: os + '-' + arch,
          dockerfile: 'docker/Dockerfile.' + os + '.' + arch,
          repo: 'covergates/' + name,
          cache_from: 'covergates/' + name,
        },
        when: {
          event: [ 'push', 'tag' ],
        },
      },
      {
        name: 'publish',
        image: 'plugins/docker:' + os + '-' + arch,
        pull: 'always',
        settings: {
          daemon_off: 'false',
          auto_tag: true,
          auto_tag_suffix: os + '-' + arch,
          dockerfile: 'docker/Dockerfile.' + os + '.' + arch,
          repo: 'covergates/' + name,
          cache_from: 'covergates/' + name,
          username: { 'from_secret': 'docker_username' },
          password: { 'from_secret': 'docker_password' },
        },
        when: {
          event: [ 'tag' ],
        },
      },
    ],
    trigger: {
      ref: [
        'refs/heads/master',
        'refs/tags/**',
      ],
    },
  },
  notifications(os='linux', arch='amd64', depends_on=[]):: {
    kind: 'pipeline',
    name: 'notifications',
    platform: {
      os: os,
      arch: arch,
    },
    steps: [
      {
        name: 'manifest',
        image: 'plugins/manifest',
        pull: 'always',
        settings: {
          username: { from_secret: 'docker_username' },
          password: { from_secret: 'docker_password' },
          spec: 'docker/manifest.tmpl',
          ignore_missing: true,
        },
        when: {
          event: [ 'tag' ],
        },
      },
      {
        name: 'manifest-latest',
        image: 'plugins/manifest',
        pull: 'always',
        settings: {
          username: { from_secret: 'docker_username' },
          password: { from_secret: 'docker_password' },
          spec: 'docker/manifest.latest.tmpl',
          ignore_missing: true,
        },
        when: {
          event: [ 'tag' ],
        },
      }
    ],
    depends_on: depends_on,
    trigger: {
      ref: [
        'refs/heads/master',
        'refs/tags/**',
      ],
    },
  },

  signature(key):: {
    kind: 'signature',
    hmac: key,
  }
}