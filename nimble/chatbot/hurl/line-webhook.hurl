POST https://{{api_host}}/webhooks/line/{{brand}}
Content-Type: application/json
X-Line-Signature: {{signature}}

{
    "type": "new",
    "body": {
        "a": "b"
    }
}

HTTP *
[Asserts]
status toString matches "^(200|400)$"
