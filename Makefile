.PHONY: gen
gen:
	@echo "Generating abi code using solc..."
	solc @openzeppelin/=$(PWD)/node_modules/@openzeppelin/ @chainlink/=$(PWD)/node_modules/@chainlink/ --abi contracts/HeroTicket.sol -o build --overwrite
	@echo "Generating go code using abigen..."
	abigen --abi build/HeroTicket.abi --pkg=heroticket --out=gen/HeroTicket.go