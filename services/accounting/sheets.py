#!/bin/python

from __future__ import print_function
import httplib2
import os
import io
import csv
import sys

from apiclient import discovery
from apiclient.http import MediaIoBaseDownload

from oauth2client import client
from oauth2client import tools
from oauth2client.file import Storage

try:
    import argparse
    flags = argparse.ArgumentParser(parents=[tools.argparser]).parse_args()
except ImportError:
    flags = None

# If modifying these scopes, delete your previously saved credentials
# at ~/.credentials/drive-python-quickstart.json
SCOPES = 'https://www.googleapis.com/auth/drive.readonly'
CLIENT_SECRET_FILE = 'client_id.json'
APPLICATION_NAME = 'Drive API Python Quickstart'


class SheetManager:

    def __init__(self):
        credentials = self.get_credentials()
        http = credentials.authorize(httplib2.Http())
        self.drive_service = discovery.build('drive', 'v3', http=http)

    def get_credentials(self):
        """Gets valid user credentials from storage.

        If nothing has been stored, or if the stored credentials are invalid,
        the OAuth2 flow is completed to obtain the new credentials.

        Returns:
            Credentials, the obtained credential.
        """
        home_dir = os.path.expanduser('~')
        credential_dir = os.path.join(home_dir, '.credentials')
        if not os.path.exists(credential_dir):
            os.makedirs(credential_dir)
        credential_path = os.path.join(credential_dir,
                                       'drive-python-quickstart.json')

        store = Storage(credential_path)
        credentials = store.get()
        if not credentials or credentials.invalid:
            flow = client.flow_from_clientsecrets(CLIENT_SECRET_FILE, SCOPES)
            flow.user_agent = APPLICATION_NAME
            if flags:
                credentials = tools.run_flow(flow, store, flags)
            else:  # Needed only for compatibility with Python 2.6
                credentials = tools.run(flow, store)
            print('Storing credentials to ' + credential_path)
        return credentials

    def download_timesheets(self, q, subquery = '2018'):
        page_token = None
        while True:
            response = self.drive_service.files().list(q=q,
                                                       spaces='drive',
                                                       fields='nextPageToken, files(id, name, parents)',
                                                       pageToken=page_token).execute()
            for f in response.get('files', []):
                # Process change
                print('Found file: %s' % (f.get('name')))
                try:
                    self.export_sheet(f)
                except:
                    print('cant export ', f)
            page_token = response.get('nextPageToken', None)
            if page_token is None:
                break

    def export_sheet(self, f):

        request = self.drive_service.files().export_media(
            fileId=f.get('id'),
            mimeType='text/csv'  # 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        )
        fh = io.FileIO('tmp/{}.csv'.format(f.get('name')), 'w')
        downloader = MediaIoBaseDownload(fh, request)
        done = False
        while done is False:
            status, done = downloader.next_chunk()
            print("Download %d%%." % int(status.progress() * 100))

        # open().write(fh.read().decode('utf-8'))

    def tally_timesheets(self):
        tally = {}
        for filename in os.listdir("tmp/"):
            with open("tmp/" + filename, 'r') as csvfile:

                csvreader = csv.reader(csvfile)

                # This skips the first row of the CSV file.
                # csvreader.next() also works in Python 2.
                next(csvreader)
                next(csvreader)
                next(csvreader)
                next(csvreader)
                next(csvreader)

                for row in csvreader:
                    print(row)
                    if len(row) == 4:
                        amount = row[3]
                    else:
                        amount = row[4]
                    project = row[0]
                    if project not in tally:
                        tally[project] = 0.0
                    tally[project] += float(amount or '0')

        for k, v in tally.items():
            print(k, ',', v)


def main():
    """Shows basic usage of the Google Drive API.

    Creates a Google Drive API service object and outputs the names and IDs
    for up to 10 files.
    """
    manager = SheetManager()
    #manager.download_timesheets("name contains '2018-timesheet'")
    manager.tally_timesheets()


if __name__ == '__main__':
    main()
