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
    
    pandoc_dir = test_dir.parent.parent / "pandoc"

    subprocess.run(
        [
            "pandoc", str(input_md),
            "--defaults=defaults.yaml",
            f"--resource-path=.:{test_dir}",
            "-o", str(output_html)
        ],
        check=True,
        cwd=pandoc_dir
    )

    with open(output_html, "r", encoding="utf-8") as f:
        return BeautifulSoup(f, "lxml")

def test_section_numbers_exist(soup):
    """
    Tests that <span> tags with class 'header-section-number' are created.
    """
    assert soup.find("span", class_="header-section-number") is not None

def test_section_numbers_are_correct(soup):
    """
    Tests that the section numbers are correct.
    """
    numbers = [s.get_text() for s in soup.find_all("span", class_="header-section-number")]
    assert numbers == ["1", "1.1", "2"]
