.PHONY: clean test

test:
	docker-compose build
	docker-compose up --abort-on-container-exit --exit-code-from test

clean:
	docker-compose down
