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
    workspace_root = test_dir.parent.parent
    
    # For German, we need to override the default English crossref settings
    pandoc_args = [
        "pandoc", str(input_md),
        "--defaults=pandoc/defaults.yaml",
        f"--resource-path=.:{test_dir}",
        "--metadata", f"lang={lang}",
    ]
    
    # Override crossref language file for non-English
    if lang != "en-US":
        pandoc_args.extend(["--metadata-file", f"pandoc/crossref-{lang}.yaml"])
    
    pandoc_args.extend([
        "--template=pandoc/templates/default.html",
        "--css=pandoc/style.css",
        "-o", str(output_html)
    ])
    
    subprocess.run(pandoc_args, check=True, cwd=workspace_root)

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
    workspace_root = test_dir.parent.parent

    pandoc_args = [
        "pandoc", str(input_md),
        "--defaults=pandoc/defaults.yaml",
        f"--resource-path=.:{test_dir}",
        "--metadata", f"lang={lang}",
    ]
    
    # Override crossref language file for non-English
    if lang != "en-US":
        pandoc_args.extend(["--metadata-file", f"pandoc/crossref-{lang}.yaml"])
    
    pandoc_args.extend([
        "--template=pandoc/templates/default.latex",
        "-o", str(output_tex)
    ])
    
    subprocess.run(pandoc_args, check=True, cwd=workspace_root)

    with open(output_tex, "r", encoding="utf-8") as f:
        content = f.read()

    # Check for the labels
    assert r"\label{sec:one}" in content
    assert r"\caption{A test table.}\label{tbl:one}" in content
    
    # Check for the references
    assert f"See {sec_prefix}~\\ref{{sec:one}}." in content
    assert f"See {tbl_prefix}~\\ref{{tbl:one}}." in content
