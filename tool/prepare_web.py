"""Give GitHub Pages a real directory entry for the /ekko/ editor route."""
from pathlib import Path
import shutil

web = Path(__file__).resolve().parents[1] / 'build' / 'web'
if not (web / 'index.html').exists():
    raise SystemExit('Run flutter build web before preparing routes.')
(web / 'ekko').mkdir(exist_ok=True)
shutil.copyfile(web / 'index.html', web / 'ekko' / 'index.html')
