all: lint

lint:
	luacheck --config .luacheckrc .

unit:
	lua tests/init.lua -v
