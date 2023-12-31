SRC_DIR=src
BIN_DIR=bin
BINLIB_DIR=$(BIN_DIR)/lib
LIB_DIR=$(SRC_DIR)/lib
CMD_DIR=$(SRC_DIR)/cmd
VENDOR_DIR=$(SRC_DIR)/vendor
VENDORS_DIRS := $(shell ls ${VENDOR_DIR} | xargs printf -- " -I${VENDOR_DIR}/%s")
VENDORS_INCLUDE_DIRS := $(shell ls ${VENDOR_DIR} | xargs printf -- " -I${VENDOR_DIR}/%s/include")

CC=g++
CFLAGS=-std=c++17 -Wall -O3 -I$(SRC_DIR) -I$(VENDOR_DIR)$(VENDORS_DIRS)$(VENDORS_INCLUDE_DIRS)

EXEC_PREFIX=wagent_

LIB_SOURCES=$(wildcard $(LIB_DIR)/*.cpp)
LIB_TARGETS=$(subst $(LIB_DIR), $(BINLIB_DIR), $(LIB_SOURCES:.cpp=.o))

CMD_SOURCES=$(wildcard $(CMD_DIR)/*.cpp)
CMD_TARGETS=$(subst $(CMD_DIR), $(BIN_DIR), $(CMD_SOURCES:.cpp=.o))

CMD_EXECS=$(subst $(BIN_DIR)/, $(BIN_DIR)/$(EXEC_PREFIX), $(CMD_TARGETS:.o=))

all: mkdirs $(LIB_TARGETS) $(CMD_TARGETS)
	$(MAKE) $(CMD_EXECS)
	$(MAKE) clean

$(BIN_DIR)/$(EXEC_PREFIX)%: $(CMD_DIR)/%.cpp
	$(CC) $(CFLAGS) $(CFLAGS_EXTRA) -o $@ $(BINLIB_DIR)/*.o $(BIN_DIR)/$*.o

$(BIN_DIR)/%.o: $(CMD_DIR)/%.cpp
	$(CC) $(CFLAGS) $(CFLAGS_EXTRA) -c $^ -o $@

$(BINLIB_DIR)/%.o: $(LIB_DIR)/%.cpp
	$(CC) $(CFLAGS) $(CFLAGS_EXTRA) -c $^ -o $@

mkdirs:
	mkdir -p $(BIN_DIR) $(BINLIB_DIR)

.PHONY: clean

clean:
	rm -rf $(CMD_TARGETS) $(BINLIB_DIR)

clear:
	$(MAKE) clean
	rm -rf $(CMD_EXECS)

rebuild:
	$(MAKE) clear
	$(MAKE) -j
