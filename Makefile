#Makefile help cleaning up docker.

DOCKER = docker

.PHONY: help
help: ## Display callable targets.
	@echo "Reference card for usual actions."
	@echo "Here are available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.PHONY: stop
stop: ## Stop all containers.
	${DOCKER} stop $(${DOCKER} ps -q)


.PHONY: killall
kill: ## Kill all containers.
	${DOCKER} kill $(${DOCKER} ps -q)


.PHONY: rmall
rm: ## Removes all containers.
	${DOCKER} rm $(${DOCKER} ps -a -q)


.PHONY: rmi
rmi: ## Removes all images.
	${DOCKER} rmi -f $(${DOCKER} images -a -q)

# #.PHONY: rmi
# rmi: ## Deletes all docker images and volumes defined in the Compose file.
# 	${DOCKER} container prune -f
# 	${DOCKERCOMPOSE_DEV} down --rmi all --volumes --remove-orphans


.PHONY: rmdi
rmdi: ## Removes dangling images.
	${DOCKER} rmi $(${DOCKER} images -a --filter=dangling=true -q)


.PHONY: rm-exited-containers
rm-exited-containers: ## Removes containers that are done.
	${DOCKER} rm -v $(${DOCKER} ps -a -q -f status=exited)


.PHONY: prune
prune: kill ## Removes containers that are done.

	${DOCKER} containers prune -f
	${DOCKER} images prune -a -f
	${DOCKER} system prune -a -f


.PHONY: debug
debug: ## Runs a docker service with service ports turned on (for pdb to work).
ifdef SERVICE
		${DOCKERCOMPOSE_DEV} kill $(SERVICE)
		${DOCKERCOMPOSE_DEV} run --service-ports $(SERVICE)
else
		@echo "Please define SERVICE environment/make variable. Example:"
		@echo
		@echo "SERVICE=web make debug"
		@echo
		@echo "-- or --"
		@echo
		@echo "make debug SERVICE=web"
		@echo
endif


.PHONY: logs
logs: ## Tails an docker services logs.
ifdef SERVICE
		${DOCKERCOMPOSE_DEV} logs -f --tail=400 $(SERVICE)
else
		@echo "Please define SERVICE environment/make variable. Example:"
		@echo
		@echo "SERVICE=web make logs"
		@echo
		@echo "-- or --"
		@echo
		@echo "make logs SERVICE=web"
		@echo
endif


.PHONY: exec
exec: ## Execs into running container.
ifdef SERVICE
		${DOCKERCOMPOSE_DEV} exec $(SERVICE) /bin/bash
else
		@echo "Please define SERVICE environment/make variable. Example:"
		@echo
		@echo "SERVICE=web make exec"
		@echo
		@echo "-- or --"
		@echo
		@echo "make exec SERVICE=web"
		@echo
endif

