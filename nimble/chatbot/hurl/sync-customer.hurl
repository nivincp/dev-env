# sync the customer profile to okya web
POST https://{{tenant_host}}/api/v1/auth/okya/callback
Content-Type: application/json
Authorization: Bearer {{access_token}}
{
    "id_token": "{{id_token}}"
}
HTTP *
[Asserts]
status toString matches "^(200|422)$"

