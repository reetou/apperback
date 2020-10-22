# Apperback

Backend for mobile app builder - Apper (https://github.com/reetou/apper)

User can store projects and build them. Build is happening inside gitlab CI runners when backend sends request to Gitlab Pipeline API (see `lib/apperback/project_build.ex`) to trigger pipeline job by name (ios, android, publish js bundle) in special repo that contains scripts for building and publishing React-Native app to Expo.io servers.

Sooner I realized that this project is not a one-man job and decided to abandon it. 

It worked tho.

I decided to omit auth part when building MVP until launch phase but it did not happen so there's no auth.

You can generate auth token this way:

- `mix deps.get`
- `iex -S mix`
- Then type this in terminal: `ApperbackWeb.AuthService.sign(%Apperback.User{id: "123"})`
- You will get token to use when sending requests to `/api/projects`

### TODO
1. Add these env vars to ansible config so it would work when deployed:
    - GITLAB_PROJECT_ID
    - GITLAB_TRIGGER_TOKEN
    - GITLAB_PROJECT_ACCESS_TOKEN
