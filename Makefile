

.PHONY: help
help: ## Display callable targets.
	@echo "Reference card for usual actions."
	@echo "Here are available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.PHONY: stop
stop: ## Stop all containers.
	docker stop -t 0 $(docker ps -q)

.PHONY: kill
kill: ## Kill all containers.
	docker kill $(docker ps -q)

.PHONY: rm-dang-images
rm-dang-images: ## Removes dangling images.
	docker rmi $(docker images -a --filter=dangling=true -q)

.PHONY: rm-exited-containers
rm-exited-containers: ## Removes containers that are done.
	docker rm -v $(docker ps -a -q -f status=exited)
