CONFIG_DIR = boards/shields/portago9

SRCS_BODY = $(shell find $(CONFIG_DIR) -type f ! -name "*_dongle*")
SRCS_DONGLE = $(shell find $(CONFIG_DIR) -type f ! -name "*_body*")

TARGET_BODY = ../zmk/app/build/body/zephyr/zmk.uf2
TARGET_DONGLE = ../zmk/app/build/dongle/zephyr/zmk.uf2

.PHONY: build clean

build: $(TARGET_BODY) $(TARGET_DONGLE)

$(TARGET_BODY): $(SRCS_BODY)
	docker exec -w /workspaces/zmk/app -it $(container_name) west build -d build/body -b seeeduino_xiao_ble -- -DSHIELD=portago9_body -DZMK_CONFIG="/workspaces/zmk-config"
	docker exec -w /workspaces/zmk/app -it $(container_name) cp build/body/zephyr/zmk.uf2 /workspaces/zmk-config/portago9_body.uf2

$(TARGET_DONGLE): $(SRCS_DONGLE)
	docker exec -w /workspaces/zmk/app -it $(container_name) west build -d build/dongle -b seeeduino_xiao_ble -- -DSHIELD="portago9_dongle prospector_adapter" -DZMK_CONFIG="/workspaces/zmk-config" -DZMK_EXTRA_MODULES="/workspaces/zmk-modules/prospector-zmk-module"
	docker exec -w /workspaces/zmk/app -it $(container_name) cp build/dongle/zephyr/zmk.uf2 /workspaces/zmk-config/portago9_dongle.uf2

clean:
	docker exec -it $(container_name) rm -rf /workspaces/zmk/app/build
