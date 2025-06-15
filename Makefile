CONOFIG_DIR = config

SRCS = $(shell find $(CONFIG_DIR) -type f)

TARGET = ../zmk/app/build/zephyr/zmk.uf2

.PHONY: build clean

build: $(TARGET)

$(TARGET): $(SRCS)
	docker exec -w /workspaces/zmk/app -it $(container_name) west build -b seeeduino_xiao_ble -- -DSHIELD=portago9 -DZMK_CONFIG="/workspaces/zmk-config"
	docker exec -w /workspaces/zmk/app -it $(container_name) cp build/zephyr/zmk.uf2 /workspaces/zmk-config/portago9.uf2

clean:
	docker exec -it $(container_name) rm -rf /workspaces/zmk/app/build
