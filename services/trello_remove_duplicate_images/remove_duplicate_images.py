from dotenv import load_dotenv, find_dotenv
from trello import TrelloClient
import os

load_dotenv(find_dotenv())

client = TrelloClient(
    api_key=os.environ.get("API_KEY"),
    api_secret=os.environ.get("API_SECRET")
)

boards = client.list_boards();

def remove_duplicate_attachments():
	for board in boards:
		cards = board.get_cards({ 'filters': 'open', 'fields': 'all' })

		for card in cards:
			attachments = card.get_attachments()

			seen = set()
			for d in attachments:
				t = tuple([('edge_color', d.edge_color), ('name', d.name), ('bytes', d.bytes)])
				if t not in seen:
					seen.add(t)
				else:
					card.remove_attachment(d.id)


if __name__ == '__main__':
	remove_duplicate_attachments()
