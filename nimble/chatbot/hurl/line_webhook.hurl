POST {{api_host}}/webhooks/line/{{brand}}
Content-Type: application/json
X-Line-Signature: {{signature}}

{
    "type": "new",
    "body": {
        "a": "b"
    }
}

HTTP 200