import json
from spotipy.oauth2 import SpotifyClientCredentials
import os
import spotipy
import boto3
from datetime import datetime

def lambda_handler(event, context):
    # Retrieve Spotify API credentials from environment variables (do not hardcode sensitive data)
    client_id = os.environ.get('client_id')
    client_secret = os.environ.get('client_secret')
    client_credentials_manager = SpotifyClientCredentials(
        client_id=client_id,
        client_secret=client_secret
    )
    # Initialize Spotipy client with credentials
    sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)
    
    # (Optional) Get all playlists for the Spotify user (not used further in this script)
    playlists = sp.user_playlists('spotify')

    # Specify the Spotify playlist link to extract data from
    playlist_link = 'https://open.spotify.com/playlist/6VOedaf3eNWDOVpa9Qdlvg'
    playlist_uri = playlist_link.split("/")[-1]  # Extract playlist URI from the link
    data = sp.playlist_tracks(playlist_uri)      # Fetch playlist tracks data

    # Initialize AWS S3 client
    client = boto3.client('s3')
    # Generate a unique filename using the current timestamp
    filename = 'spotify_raw_' + str(datetime.now()) + '.json'
    # Upload the raw playlist data as a JSON file to the specified S3 bucket and path
    client.put_object(
        Bucket='spotify-etl-prj-py',
        Key='raw_data/to_processed/' + filename,
        Body=json.dumps(data)
    )