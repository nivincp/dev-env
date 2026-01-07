# ---------- Postgres ----------
PG_COMPOSE = postgres.yaml
PG_CONTAINER = local-postgres
PG_DB = appdb
PG_USER = appuser

.PHONY: \
	pg-up pg-down pg-restart pg-logs pg-ps pg-psql pg-reset \
	glances-up glances-down glances-restart glances-logs glances-ps


# ===== Postgres =====
pg-up:
	docker compose -f $(PG_COMPOSE) up -d

pg-down:
	docker compose -f $(PG_COMPOSE) down

pg-restart:
	docker compose -f $(PG_COMPOSE) down
	docker compose -f $(PG_COMPOSE) up -d

pg-logs:
	docker compose -f $(PG_COMPOSE) logs -f

pg-ps:
	docker compose -f $(PG_COMPOSE) ps

pg-psql:
	docker exec -it $(PG_CONTAINER) psql -U $(PG_USER) -d $(PG_DB)

pg-reset:
	docker compose -f $(PG_COMPOSE) down -v
