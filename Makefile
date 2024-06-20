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

.PHONY: build
build:
	forge build

.PHONY: test
test:
	forge test

.PHONY: start-anvil
start-anvil:
	anvil

.PHONY: deploy-anvil
deploy-anvil:
	mkdir -p temp
	forge script \
		script/Deploy.s.sol:Deploy \
		--fork-url ${ANVIL_RPC_URL} \
		--broadcast \
		--private-key=${ETH_PRIVKEY_0_ANVIL}

.PHONY: set-sample-seed
set-sample-seed:
	BTC_ADDR1=tb1p5z8wl5tu7m0d79vzqqsl9gu0x4fkjug857fusx4fl4kfgwh5j25spa7245 \
	BTC_ADDR2=tb1pfusykjdt46ktwq03d20uqqf94uh9487344wr3q5v9szzsxnjdfks9apcjz \
	BTC_NETWORK=0 \
	forge script \
		-vvv \
		script/SetSeed.s.sol:SetSeed \
		--fork-url ${ANVIL_RPC_URL} \
		--broadcast \
		--private-key=${ETH_PRIVKEY_0_ANVIL}

.PHONY: get-sample-btc-address
get-sample-btc-address:
	ETH_ADDR=${ETH_ADDR_1_ANVIL} \
	BTC_ADDR_FILE=./temp/btc.address \
	forge script -vvv \
		script/GetBtcAddr.s.sol:GetBtcAddr \
		--fork-url ${ANVIL_RPC_URL}

.PHONY: test-sample-flow
test-sample-flow:
	@$(MAKE) -f $(THIS_FILE) deploy-anvil
	@$(MAKE) -f $(THIS_FILE) set-sample-seed
	@$(MAKE) -f $(THIS_FILE) get-sample-btc-address
	if [ `cat ./temp/btc.address` = "1tb1pxt2g6ltjvle3wupwzlg9yuqw5rsswvvjg20eegq46l3yx6ekc2psh78607" ]; \
	then \
		echo "${GREEN}OK${RESET}"; \
		exit 0; \
	else \
		echo "${RED}ERROR${RESET}"; \
		exit 1; \
	fi

.PHONY: clean
clean:
	rm -rf cache
	rm -rf out