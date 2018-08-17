from trello import TrelloClient
import os

client = TrelloClient(
    api_key=os.environ.get("TRELLO_API_KEY"),
    api_secret=os.environ.get("TRELLO_API_SECRET")
)

boards = client.list_boards()


def archive_done_cards():
    for board in boards:
        current_board = board
        open_lists = current_board.get_lists("open")

        for curr_list in open_lists:
            if curr_list.name == "Done":
                print(board.name, 'is being archived.')
                curr_list.archive_all_cards()
                break


if __name__ == '__main__':
    archive_done_cards()
