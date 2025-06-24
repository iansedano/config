import argparse
from pathlib import Path


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("in_file")

    return parser.parse_args()


def build_row(image_link, text, article_link, video_link):
    article_part = f'<a href="{article_link}">📰</a>' if article_link else ""
    video_part = f'<a href="{video_link}">🎬</a>' if article_link else ""

    article_video_part = (
        f"{article_part} <br/> {video_part}"
        if article_link and video_link
        else f"{article_part}"
    )

    return f'| {article_video_part} | ![width:230px]({image_link}) | <a href="{article_link}" class="text-sm">{text}</a>\n'


def parse_text(text):
    return [
        dict(i.strip().split(":", 1) for i in item.strip().split("\n"))
        for item in text.strip().split("---")
    ]


def build_table(data):

    table = ['<div class="no-border">\n\n|  | |  |\n| ----------- | --- | --- |\n']

    for item in data:
        table.append(
            build_row(
                item["IMAGE"],
                item["TEXT"],
                item["ARTICLE"],
                item["VIDEO"] if "VIDEO" in item else None,
            )
        )

    table.append("\n</div>\n")

    return "".join(table)


if __name__ == "__main__":
    args = parse_args()
    data = parse_text(Path(args.in_file).read_text(encoding="utf-8"))
    table = build_table(data)
    print(table)
