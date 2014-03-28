MOCHA = ./node_modules/.bin/mocha

all: test

test:
	@NODE_ENV=test $(MOCHA) \
		--compilers coffee:coffee-script \
		--reporter spec \
		--require coffee-script \
		--require should \

.PHONY: test
