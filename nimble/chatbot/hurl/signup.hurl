# signup as a user
POST https://{{auth_host}}//api/v1/connections/signup?client_id={{client_id}}
Content-Type: application/json
{
  "email": "{{email}}",
  "given_name": "Guest",
  "family_name": "Line",
  "birthdate": "1990-01-01",
  "password": "{{password}}",
  "metadata": {
    "x": 1
  }
}
HTTP *
[Asserts]
status toString matches "^(200|422)$"
