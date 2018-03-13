# step-buildnumber-generator
Wercker Step to generate build number from build number generator service

## wecker.yml

```
deploy:
    steps:
    - cashrewards/buildnumber-generator:
        name: example
        base_url: $PL_BUILD_NUMBER_API_URL
        api_key: $PL_BUILD_NUMBER_API_KEY
        app: ${WERCKER_GIT_REPOSITORY}-${WERCKER_GIT_BRANCH}
        directory: wercker
```

