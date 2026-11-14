VENV := .venv
BIN := $(VENV)/bin

.PHONY: install lint format typecheck test check clean

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

clean:
	rm -rf .ruff_cache .mypy_cache .pytest_cache build dist *.egg-info
