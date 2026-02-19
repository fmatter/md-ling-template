import pytest
from bs4 import BeautifulSoup
from pathlib import Path
import subprocess

@pytest.fixture(scope="module")
def soup():
    """
    A pytest fixture that runs Pandoc to generate the test HTML,
    then parses it with BeautifulSoup.
    """
    test_dir = Path(__file__).parent
    input_md = test_dir / "input.md"
    output_html = test_dir / "output.html"
    
    base_dir = test_dir.parent.parent
    defaults_path = base_dir / "pandoc" / "defaults.yaml"
    # The resource path needs to include the test directory itself so it can find sources.bib
    resource_path = f".:{base_dir / 'pandoc'}:{test_dir}"

    subprocess.run(
        [
            "pandoc", str(input_md),
            "--defaults", str(defaults_path),
            "--resource-path", resource_path,
            "-o", str(output_html)
        ],
        check=True,
    )

    with open(output_html, "r", encoding="utf-8") as f:
        return BeautifulSoup(f, "lxml")

def test_bibliography_heading_exists(soup):
    """
    Tests if the default 'Bibliography' heading is created.
    """
    heading = soup.find("h1", id="bibliography")
    assert heading is not None
    assert heading.get_text() == "Bibliography"

def test_citation_is_rendered(soup):
    """
    Tests if the content from the .bib file appears in the document.
    """
    # Find the references div
    refs_div = soup.find("div", id="refs")
    assert refs_div is not None
    
    # Check for some text that can only come from the .bib file
    assert "Author, Test" in refs_div.get_text()
    # Check for the title, being mindful of potential line breaks
    assert "An Article for Testing" in refs_div.get_text()
    assert "Bibliographies" in refs_div.get_text()
