# Covergates

This is the Drone Plugin for uploading report to [Covergates](https://github.com/covergates/covergates).
Below pipeline configuration shows how to use it:

```.yml
kind: pipeline
name: default
steps:
  - name: upload
    image: covergates/drone-covergates
    settings:
      report_id: bt9huh223akg00dkqseg
      report: ./coverage/lcov.info
      type: lcov
```

To leave comment on pull request:

```.yml
kind: pipeline
name: default
steps:
  - name: upload
    image: covergates/drone-covergates
    settings:
      report_id: bt9huh223akg00dkqseg
      report: ./coverage/lcov.info
      type: lcov
      comment: true
    when:
      event:
        - pull_request
```

Available arguments:

- `report_id`: `Report ID` found in repository setting
- `report`: coverage report
- `type`: report type, please refer to [documents](https://docs.covergates.com/start/cli/#upload-command) for more detail
- `comment`: set true to leave a comment on your pull request

> :warning: Current version supports Linux x64, ARM and ARM x64 container.
