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
    
    pandoc_dir = test_dir.parent.parent / "pandoc"

    # Run pandoc to generate the output file
    subprocess.run(
        [
            "pandoc", str(input_md),
            "--defaults=defaults.yaml",
            f"--resource-path=.:{test_dir}",
            "--template=templates/default.html",
            "--css=style.css",
            "-o", str(output_html)
        ],
        check=True,
        cwd=pandoc_dir
    )

    # Now, read the generated file and return the soup
    with open(output_html, "r", encoding="utf-8") as f:
        return BeautifulSoup(f, "lxml")

@pytest.fixture(scope="module")
def latex_output():
    """
    A pytest fixture that runs Pandoc to generate the test LaTeX output.
    """
    test_dir = Path(__file__).parent
    input_md = test_dir / "input.md"
    output_tex = test_dir / "output.tex"
    pandoc_dir = test_dir.parent.parent / "pandoc"

    subprocess.run(
        [
            "pandoc", str(input_md),
            "--defaults=defaults.yaml",
            f"--resource-path=.:{test_dir}",
            "--template=templates/default.latex",
            "-o", str(output_tex)
        ],
        check=True,
        cwd=pandoc_dir
    )

    with open(output_tex, "r", encoding="utf-8") as f:
        return f.read()

def test_smallcaps_span_exists(soup):
    """
    Tests if a span with the 'smallcaps' class exists.
    """
    assert soup.find("span", class_="smallcaps") is not None

def test_smallcaps_text_is_correct(soup):
    """
    Tests if the text inside the span is 'ACC'.
    """
    span = soup.find("span", class_="smallcaps")
    assert span.get_text() == "ACC"

def test_css_is_linked(soup):
    """
    Tests if the style.css file is linked correctly.
    """
    link = soup.find("link", rel="stylesheet")
    assert link is not None
    # The href should be relative to the output.html file's location
    assert "style.css" in link["href"]

def test_smallcaps_in_latex(latex_output):
    """
    Tests that the LaTeX output includes the \textsc command.
    """
    assert r"\textsc{ACC}" in latex_output
