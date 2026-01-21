POST http://{{api_host}}/webhooks/line/{{brand}}
Content-Type: application/json
X-Line-Signature: {{signature}}
{"events":[{"type":"message","message":{"id":"1234567890","type":"text","text":"Hello from LINE"},"timestamp":1710000000000,"source":{"type":"user","userId":"Uxxxxxxxxxxxx"}}]}
HTTP *
[Asserts]
status toString matches "^(200|400)$"
