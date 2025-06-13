import logging
from pathlib import Path

LOG_DIR = Path("/data/data/com.termux/files/home/flash-termux/logs")
LOG_FILE = LOG_DIR / "flash.log"

def setup_logger():
    LOG_DIR.mkdir(exist_ok=True)
    logging.basicConfig(
        filename=LOG_FILE,
        level=logging.INFO,
        format='[%(asctime)s] %(message)s'
    )
    return logging.getLogger()

log = setup_logger()