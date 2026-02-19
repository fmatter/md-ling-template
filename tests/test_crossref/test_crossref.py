import pytest
from bs4 import BeautifulSoup
from pathlib import Path
import subprocess
import shutil

# Define the test cases for each language
@pytest.mark.parametrize("lang, sec_label, tbl_label, tbl_title", [
    ("en-US", "Section", "Table", "Table"),
    ("de-DE", "Abschnitt", "Tabelle", "Tabelle")
])
def test_crossref_labels(lang, sec_label, tbl_label, tbl_title):
    """
    Tests that pandoc-crossref generates the correct, language-specific
    labels for sections and tables.
    """
    test_dir = Path(__file__).parent
    input_md = test_dir / "input.md"
    # Create a unique output file for each language to avoid race conditions
    output_html = test_dir / f"output_{lang}.html"
    
    # The pandoc command needs to be run from the directory where the defaults file is
    # so that crossref can find its own YAML files.
    pandoc_dir = test_dir.parent.parent / "pandoc"

    # Run pandoc, passing the current language as metadata
    subprocess.run(
        [
            "pandoc", str(input_md),
            "--defaults=defaults.yaml",
            f"--resource-path=.:{test_dir}",
            "--metadata", f"lang={lang}",
            "--metadata", f"crossrefYaml=crossref-{lang}.yaml",
            "-o", str(output_html)
        ],
        check=True,
        cwd=pandoc_dir
    )

    with open(output_html, "r", encoding="utf-8") as f:
        soup = BeautifulSoup(f, "lxml")

    # Find the paragraph containing the section reference
    sec_ref_link = soup.find("a", href="#sec:one")
    p_sec = sec_ref_link.find_parent("p")
    assert p_sec is not None
    # Use non-breaking space `\xa0` which pandoc uses
    assert p_sec.get_text() == f"See {sec_label}\xa01."

    # Find the paragraph containing the table reference
    tbl_ref_link = soup.find("a", href="#tbl:one")
    p_tbl = tbl_ref_link.find_parent("p")
    assert p_tbl is not None
    assert p_tbl.get_text() == f"See {tbl_label}\xa01."

    # Test the table caption title
    caption = soup.find("caption")
    assert caption is not None, f"Table caption not found for lang '{lang}'"
    assert caption.get_text().strip().startswith(f"{tbl_title} 1:")

@pytest.mark.parametrize("lang, sec_prefix, tbl_prefix", [
    ("en-US", "Section", "Table"),
    ("de-DE", "Abschnitt", "Tabelle")
])
def test_crossref_in_latex(lang, sec_prefix, tbl_prefix):
    """
    Tests that pandoc-crossref generates the correct LaTeX labels and refs.
    """
    test_dir = Path(__file__).parent
    input_md = test_dir / "input.md"
    output_tex = test_dir / f"output_{lang}.tex"
    pandoc_dir = test_dir.parent.parent / "pandoc"

    subprocess.run(
        [
            "pandoc", str(input_md),
            "--defaults=defaults.yaml",
            f"--resource-path=.:{test_dir}",
            "--metadata", f"lang={lang}",
            "--metadata", f"crossrefYaml=crossref-{lang}.yaml",
            "--template=templates/default.latex",
            "-o", str(output_tex)
        ],
        check=True,
        cwd=pandoc_dir
    )

    with open(output_tex, "r", encoding="utf-8") as f:
        content = f.read()

    # Check for the labels
    assert r"\label{sec:one}" in content
    assert r"\caption{A test table.}\label{tbl:one}" in content
    
    # Check for the references
    assert f"See {sec_prefix}~\\ref{{sec:one}}." in content
    assert f"See {tbl_prefix}~\\ref{{tbl:one}}." in content
