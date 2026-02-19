import pytest
from bs4 import BeautifulSoup
from pathlib import Path
import subprocess

@pytest.fixture(scope="module")
def soup():
    """
    A pytest fixture that runs Pandoc to generate the test HTML,
    then parses it with BeautifulSoup. The scope is "module" so this
    only runs once per test file.
    """
    test_dir = Path(__file__).parent
    input_md = test_dir / "input.md"
    output_html = test_dir / "output.html"
    
    # Construct absolute paths from the test file's location
    base_dir = test_dir.parent.parent
    defaults_path = base_dir / "pandoc" / "defaults.yaml"
    resource_path = f".:{base_dir / 'pandoc'}"

    # Run pandoc to generate the output file
    subprocess.run(
        [
            "pandoc", str(input_md),
            "--defaults", str(defaults_path),
            "--resource-path", resource_path,
            "-o", str(output_html)
        ],
        check=True,
    )

    # Now, read the generated file and return the soup
    with open(output_html, "r", encoding="utf-8") as f:
        return BeautifulSoup(f, "lxml")

def test_smallcaps_span_exists(soup):
    """
    Tests if a span with the 'gloss' class exists.
    """
    assert soup.find("span", class_="gloss") is not None

def test_smallcaps_text_is_correct(soup):
    """
    Tests if the text inside the span is 'ACC'.
    """
    span = soup.find("span", class_="gloss")
    assert span.get_text() == "ACC"

def test_css_is_linked(soup):
    """
    Tests if the style.css file is linked correctly.
    """
    link = soup.find("link", rel="stylesheet")
    assert link is not None
    # The href should be relative to the output.html file's location
    assert "style.css" in link["href"]
