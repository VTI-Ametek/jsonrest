VERSION := $(shell awk '/version/ {print $$3}' setup.cfg)

PY_SRC = src/jsonrest/*.py
PY_CFG = setup.cfg pyproject.toml README.md LICENSE

DIST_DIR = dist
WHL = $(DIST_DIR)/jsonrest-$(VERSION)-py3-none-any.whl
DOC_DIR = doc
TOP_DOC = $(DOC_DIR)/jsonrest.html
EXTRA_DOC_FILES = vxitech.png

all: $(WHL) $(TOP_DOC)

$(WHL): $(PY_CFG) $(PY_SRC)
	python3 -m build

$(TOP_DOC): $(PY_SRC) $(EXTRA_DOC_FILES) README.md
	pdoc src/jsonrest -o $(DOC_DIR) --logo vxitech.png
	cp $(EXTRA_DOC_FILES) $(DOC_DIR)

lint:
	python2 -m pylint src/jsonrest

clean:
	rm -rf $(DIST_DIR) $(DOC_DIR) ./src/jsonrest/__pycache__ ./src/jsonrest.egg-info
