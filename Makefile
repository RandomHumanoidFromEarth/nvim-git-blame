all: lint

lint:
	luacheck --config .luacheckrc .
