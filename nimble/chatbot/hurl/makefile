VARS_FILE=vars.env
HURL=hurl --variables-file $(VARS_FILE)

# Push event
line_webhook:
	@$(HURL) line_webhook.hurl | jq .
