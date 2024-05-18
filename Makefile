all: lint test

lint:
	luacheck --config .luacheckrc .

test:
	lua tests/init.lua -v
