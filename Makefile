# https://stackoverflow.com/questions/5377297/how-to-manually-call-another-target-from-a-make-target
# Determine this makefile's path.
# Be sure to place this BEFORE `include` directives, if any.
THIS_FILE := $(lastword $(MAKEFILE_LIST))

# Keys are generated determistically in anvil so they are the same during different runs
# as long the seed is the same.
# Some keys and addresses are copy-pasted in file `env-anvil`.
# https://unix.stackexchange.com/questions/235223/makefile-include-env-file
include env-anvil
export $(shell sed 's/=.*//' env-anvil)

RED    := $(shell tput -Txterm setaf 1)
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

.PHONY: default
default: help

## Build:
.PHONY: build
build: ## Build library.
	forge build

.PHONY: clean
clean: ## Clean tempory files. Sometimes forge incorrectly updates its cache. So if there are some strange errors run `make clean`.
	rm -rf cache
	rm -rf out

## Work with local anvil:
.PHONY: start-anvil
start-anvil: ## Starts anvil with default parameters.
	anvil

.PHONY: deploy-on-anvil
deploy-on-anvil: ## Deploy BTCDepositAddressDeriver smart contract on local anvil blockchain.
	mkdir -p temp
	forge script \
		script/Deploy.s.sol:Deploy \
		--fork-url ${ANVIL_RPC_URL} \
		--broadcast \
		--private-key=${ETH_PRIVKEY_0_ANVIL}

.PHONY: set-sample-seed
set-sample-seed: ## Set sample seed on previously deployed BTCDepositAddressDeriver.
	BTC_ADDR1=tb1p5z8wl5tu7m0d79vzqqsl9gu0x4fkjug857fusx4fl4kfgwh5j25spa7245 \
	BTC_ADDR2=tb1pfusykjdt46ktwq03d20uqqf94uh9487344wr3q5v9szzsxnjdfks9apcjz \
	BTC_NETWORK=1 \
	forge script \
		-vvv \
		script/SetSeed.s.sol:SetSeed \
		--fork-url ${ANVIL_RPC_URL} \
		--broadcast \
		--private-key=${ETH_PRIVKEY_0_ANVIL}

.PHONY: get-sample-btc-address
get-sample-btc-address: ## Calculates bitcoin address from the sample ethereum address using  previously deployed BTCDepositAddressDeriver.
	ETH_ADDR=${ETH_ADDR_1_ANVIL} \
	BTC_ADDR_FILE=./temp/btc.address \
	forge script -vvv \
		script/GetBtcAddr.s.sol:GetBtcAddr \
		--fork-url ${ANVIL_RPC_URL}

## Test:
.PHONY: test
test: ## Run unit tests.
	forge test

.PHONY: test-sample-flow
test-sample-flow: ## Run integration test that deploys smart contract, set seed and calculate sample bitcoin address. It requires anvil to be running.
	@$(MAKE) -f $(THIS_FILE) deploy-on-anvil
	@$(MAKE) -f $(THIS_FILE) set-sample-seed
	@$(MAKE) -f $(THIS_FILE) get-sample-btc-address
	if [ `cat ./temp/btc.address` = "tb1pxt2g6ltjvle3wupwzlg9yuqw5rsswvvjg20eegq46l3yx6ekc2psh78607" ]; \
	then \
		echo "${GREEN}OK${RESET}"; \
		exit 0; \
	else \
		echo "${RED}ERROR${RESET}"; \
		exit 1; \
	fi

.PHONY: test-all
test-all: test test-sample-flow ## Run unit and integrations tests. It requires anvil to be running.

## Help:
.PHONY: help
help: ## Show this help
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z0-9_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-25s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)