POST {{API_HOST}}/webhooks/line/{{BRAND}}
Content-Type: application/json
X-Line-Signature: {{SIGNATURE}}

{
    "type": "new",
    "body": {
        "a": "b"
    }
}

HTTP 200