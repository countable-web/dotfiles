#!/bin/python

from __future__ import print_function
import httplib2
import os
import io

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

    def download_timesheets(self, q):
        page_token = None
        while True:
            response = self.drive_service.files().list(q=q,
                                                       spaces='drive',
                                                       fields='nextPageToken, files(id, name, parents)',
                                                       pageToken=page_token).execute()
            for f in response.get('files', []):
                # Process change
                print('Found file: %s' % (f.get('name')))
                self.export_sheet(f)
            page_token = response.get('nextPageToken', None)
            if page_token is None:
                break

    def export_sheet(self, f):

        request = self.drive_service.files().export_media(
            fileId=f.get('id'),
            mimeType='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        )
        fh = io.FileIO('tmp/{}.xlsx'.format(f.get('name')), 'w')
        downloader = MediaIoBaseDownload(fh, request)
        done = False
        while done is False:
            status, done = downloader.next_chunk()
            print("Download %d%%." % int(status.progress() * 100))

        # open().write(fh.read().decode('utf-8'))


def main():
    """Shows basic usage of the Google Drive API.

    Creates a Google Drive API service object and outputs the names and IDs
    for up to 10 files.
    """
    manager = SheetManager()
    manager.download_timesheets("name contains '2017-timesheet'")


if __name__ == '__main__':
    main()
