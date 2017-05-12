#Makefile help cleaning up docker.


.PHONY: help
help: ## Display callable targets.
	@echo "Reference card for usual actions."
	@echo "Here are available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

DOCKER = docker

.PHONY: stop
stop: ## Stop all containers.
	${DOCKER} stop $(${DOCKER} ps -q)


.PHONY: kill
kill: ## Kill all containers.
	${DOCKER} kill $(${DOCKER} ps -q)


.PHONY: rm
rm: ## Removes all containers.
	${DOCKER} rm $(${DOCKER} ps -a -q)


.PHONY: rm-images
rm-images: ## Removes all images.
	${DOCKER} rmi -f $(${DOCKER} images -a -q)


.PHONY: rm-dang-images
rm-dang-images: ## Removes dangling images.
	${DOCKER} rmi $(${DOCKER} images -a --filter=dangling=true -q)


.PHONY: rm-exited-containers
rm-exited-containers: ## Removes containers that are done.
	${DOCKER} rm -v $(${DOCKER} ps -a -q -f status=exited)


.PHONY: prune
prune: kill ## Removes containers that are done.

	${DOCKER} containers prune -f
	${DOCKER} images prune -a -f
	${DOCKER} system prune -a -f