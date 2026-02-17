# get token
POST https://{{auth_host}}/oauth/token
[Form]
grant_type: password
client_id: {{client_id}}
client_secret: {{client_secret}}
username: {{email}}
password: {{password}}
scope: openid profile email
HTTP 200
