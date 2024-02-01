"""Rename recorded MPEG2-TS file groups based on their EIT data.

# Setup

```bash
python3 -m venv mpeg2ts-eit-renamer
source mpeg2ts-eit-renamer/bin/activate

pip install --upgrade pip chardet eitparser

python mpeg2ts-eit-renamer.py
```
"""

from math import ceil
from pathlib import Path
from glob import glob

from eit.eitparser import EitList


def find_title_and_episode(orig_name):
    if "(" not in orig_name:
        raise ValueError(f"Can't identify episode from name: {orig_name}")
    title, episode = orig_name.split("(")
    episode = episode.split(")")[0]
    if "/" in episode:
        episode = episode.split("/")[0]

    return title.strip(), int(episode)


def season_episode(season_length, episode):
    season = ceil(episode / season_length)
    episode_nr = episode % season_length
    if episode_nr == 0:
        episode_nr = season_length
    return f"S{season:02d}E{episode_nr:02d}"


def process_eit(fname):
    print("-" * 80)
    eit_fname = Path(fname)
    eit_parsed = EitList(fname)
    orig_name = eit_parsed.getEitName()
    try:
        title, episode = find_title_and_episode(orig_name)
        se_suffix = season_episode(26, episode)
    except ValueError as err:
        print(f"Error identifying season / episode for [{fname}]: {err}")
        title = eit_parsed.eit["name"]
        print(eit_parsed.eit["short_description"])
        print(eit_parsed.eit["description"])
        season = int(input("Enter season number: "))
        episode_nr = int(input("Enter season's episode nr: "))
        se_suffix = f"S{season:02d}E{episode_nr:02d}"

    new_name = f'{title.replace(" ", "_")}_{se_suffix}'
    print(f"New name: {new_name}")

    pairs = []
    related_files = glob(eit_fname.stem + "*")
    for related in related_files:
        full_suffix = related.lstrip(eit_fname.stem)
        pairs.append([related, f"{new_name}{full_suffix}"])

    for pair in pairs:
        source = Path(pair[0])
        target = Path(pair[1])
        if target.exists():
            print(f"ERROR: skipping file [{source}], target exists already: [{target}]")
            continue

        print(f"Renaming: [{source}] -> [{target}]")
        source.rename(target)


if __name__ == "__main__":
    eit_files = glob("*.eit")
    print(f"Found {len(eit_files)} '.eit' files, processing...")
    for eit_file in eit_files:
        process_eit(eit_file)
