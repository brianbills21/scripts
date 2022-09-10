#Write a script that writes a csv file with a list of the top most viewed YouTube videos.
#The script should take a YouTube API key as an argument and use it to query the YouTube Data API for the top most viewed videos.
#The script should then write the video title, video view count, and video ID to a csv file.
#The script should also print the video title, video view count, and video ID to the terminal.
#The script should also print the total number of views to the terminal.
#The script should also print the total number of views to a file.

import csv
import os
import argparse
from googleapiclient.discovery import build

# Set DEVELOPER_KEY to the API key value from the APIs & auth > Registered apps
# tab of
#   https://cloud.google.com/console
# Please ensure that you have enabled the YouTube Data API for your project.
DEVELOPER_KEY = "---hidden---"
YOUTUBE_API_SERVICE_NAME = "youtube"
YOUTUBE_API_VERSION = "v3"

def youtube_search(options):
  youtube = build(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION,
    developerKey=DEVELOPER_KEY)

  # Call the search.list method to retrieve results matching the specified
  # query term.
  search_response = youtube.search().list(
    q=options.q,
    part="id,snippet",
    maxResults=options.max_results
  ).execute()

  ids = [item["id"]["videoId"] for item in search_response["items"]]

  search_response = youtube.videos().list(
    part="statistics",
    ids=ids
  ).execute()

  videos_with_view_counts = [[item["id"], item["statistics"]["viewCount"]] for item in search_response["items"]]

  videos_with_view_counts.sort(key=lambda x: x[1], reverse=True)

  return [item[0] for item in videos_with_view_counts]

  # Add each result to the appropriate list, and then display the lists of
  # matching videos, channels, and playlists.
  for search_result in search_response.get("items", []):
    if search_result["id"]["kind"] == "youtube#video":
      videos.append(search_result)

  return videos

def main():
  parser = argparse.ArgumentParser(description='Search on YouTube')
  parser.add_argument("--q", help="Search term", default="Google")
  parser.add_argument("--max-results", help="Max results", default=25)
  args = parser.parse_args()

  try:
    os.remove('top_videos.csv')
  except OSError:
    pass

  with open('top_videos.csv', 'w') as csvfile:
    fieldnames = ['title', 'viewCount', 'videoId']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()
    for video in youtube_search(args):  # video is a dictionary
      print("Title: %s" % video['snippet']['title'])  # Print video title
      print("View Count: %s" % video['statistics']['viewCount'])  # video['statistics']['viewCount']
      print("Video ID: %s" % video['id']['videoId'])  # videoId
      print("\n")  # blank line

      writer.writerow({'title': video['snippet']['title'], 'viewCount': video['statistics']['viewCount'], 'videoId': video['id']['videoId']})

if __name__ == "__main__":
  main()
