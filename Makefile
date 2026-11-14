VENV := .venv
BIN := $(VENV)/bin
DATA_URL := https://m4d.iti.gr/wp-content/uploads/2024/04/web_bot_detection_dataset.zip
DATA_DIR := data/raw/web_bot_detection_dataset

.PHONY: install lint format typecheck test check data eda clean

install:  ## окружение + dev-зависимости + git-хуки
	python3 -m venv $(VENV)
	$(BIN)/pip install --upgrade pip
	$(BIN)/pip install --group dev -e .
	$(BIN)/pre-commit install

lint:  ## линтер без правок
	$(BIN)/ruff check .
	$(BIN)/ruff format --check .

format:  ## автоисправления + форматирование
	$(BIN)/ruff check --fix .
	$(BIN)/ruff format .

typecheck:
	$(BIN)/mypy

test:
	$(BIN)/pytest

check:  ## всё то же, что запустит CI
	$(BIN)/pre-commit run --all-files
	$(BIN)/pytest

data:  ## скачать открытый датасет в data/raw (в git не попадает)
	mkdir -p $(DATA_DIR)
	curl -L --fail -o $(DATA_DIR).zip $(DATA_URL)
	unzip -q -o $(DATA_DIR).zip -d $(DATA_DIR)

eda:  ## выполнить ноутбук EDA: графики в reports/figures, копия с выводами в build/
	$(BIN)/pip install --quiet --group eda
	$(BIN)/jupyter nbconvert --to notebook --execute --output-dir build notebooks/01_eda.ipynb

clean:
	rm -rf .ruff_cache .mypy_cache .pytest_cache build dist *.egg-info
