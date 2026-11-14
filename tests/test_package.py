import bot_detector


def test_version_is_set() -> None:
    assert bot_detector.__version__ == "0.1.0"
