VERSION := $(shell PYTHONPATH=src python3 -c 'import jsonrest; print(jsonrest.__version__)')

PY_SRC = src/jsonrest/*.py
PY_CFG = setup.cfg pyproject.toml README.rst LICENSE

VENV_DIR = venv
VENV_DONE = $(VENV_DIR)/.done
VENV_ACT = $(VENV_DIR)/bin/activate
DIST_DIR = dist
WHL = $(DIST_DIR)/jsonrest-$(VERSION)-py3-none-any.whl
DOC_DIR = docs
DOC_SRC = $(DOC_DIR)/*.py $(DOC_DIR)/*.rst $(DOC_DIR)/_static/* $(DOC_DIR)/_templates/**
DOCS = $(DIST_DIR)/jsonrest-$(VERSION)-docs.zip

all: $(WHL) $(DOCS)

$(VENV_DONE): requirements.txt
	test -d $(VENV_DIR) || python3 -m venv $(VENV_DIR)
	. $(VENV_ACT) && pip install -r $^
	touch $@

$(WHL): $(VENV_DONE) $(PY_CFG) $(PY_SRC)
	. $(VENV_ACT) && python3 -m build

$(DOCS): $(VENV_DIR) $(PY_SRC) $(DOC_SRC) README.rst
	. $(VENV_ACT) && make -C $(DOC_DIR) html
	cd $(DOC_DIR)/_build/html && zip -r ../../../$@ .

lint:
	python2 -m pylint src/jsonrest

clean:
	rm -rf $(VENV_DIR) $(DIST_DIR) ./src/jsonrest/__pycache__ ./src/jsonrest.egg-info
	make -C $(DOC_DIR) clean
