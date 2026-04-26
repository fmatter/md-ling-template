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
    
    workspace_root = test_dir.parent.parent

    subprocess.run(
        [
            "pandoc", str(input_md),
            "--defaults=pandoc/defaults.yaml",
            f"--resource-path=.:{test_dir}",
            "--template=templates/default.html",
            "--css=pandoc/style.css",
            "-o", str(output_html)
        ],
        check=True,
        cwd=workspace_root
    )

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
    workspace_root = test_dir.parent.parent

    subprocess.run(
        [
            "pandoc", str(input_md),
            "--defaults=pandoc/defaults.yaml",
            f"--resource-path=.:{test_dir}",
            "--template=templates/default.latex",
            "-o", str(output_tex)
        ],
        check=True,
        cwd=workspace_root
    )

    with open(output_tex, "r", encoding="utf-8") as f:
        return f.read()

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

def test_section_numbering_in_latex(latex_output):
    """
    Tests that the LaTeX output includes sectioning commands.
    """
    assert r"\section{First Section}" in latex_output
    assert r"\subsection{First Subsection}" in latex_output
    assert r"\section{Second Section}" in latex_output
