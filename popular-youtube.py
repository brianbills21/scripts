#Write a script that writes a csv file with a list of the top most viewed YouTube videos.
#The script should take a YouTube API key as an argument and use it to query the YouTube Data API for the top most viewed videos.
#The script should then write the video title, video view count, and video ID to a csv file.
#The script should also print the video title, video view count, and video ID to the terminal.
#The script should also print the total number of views to the terminal.
#The script should also print the total number of views to a file.

import csv
import sys
import requests
import json

# get the most popular videos on YouTube
def get_popular_videos(api_key):
    # set the base URL
    base_url = 'https://www.googleapis.com/youtube/v3/'
    # set the parameters
    params = {'part': 'snippet,contentDetails,statistics',
              'chart': 'mostPopular',
              'maxResults': '25',
              'key': api_key}
    # make the request
    response = requests.get(base_url + 'videos', params=params)
    # return the response
    return response.json()

# open a new file called 'report.csv' in write mode
with open('report.csv', 'w') as report_file:
    # create a csv writer object
    csv_writer = csv.writer(report_file)
    # write the header row
    csv_writer.writerow(['Title', 'Views', 'ID'])
    # get the API key from the command line
    api_key = sys.argv[1]
    # get the data
    data = get_popular_videos(api_key)
    # get the items
    items = data['items']
    # initialize the total views
    total_views = 0
    # iterate over the items
    for item in items:
        # get the video title
        video_title = item['snippet']['title']
        # get the video ID
        video_id = item['id']
        # get the number of views
        video_views = int(item['statistics']['viewCount'])
        # add to the total views
        total_views += video_views
        # write the row
        csv_writer.writerow([video_title, video_views, video_id])
    # write the total views
    csv_writer.writerow(['', '', ''])
    csv_writer.writerow(['Total Views', total_views, ''])
#Write a script that writes a csv file with a list of the top most viewed YouTube videos.
#The script should take a YouTube API key as an argument and use it to query the YouTube Data API for the top most viewed videos.
#The script should then write the video title, video view count, and video ID to a csv file.
#The script should also print the video title, video view count, and video ID to the terminal.
#The script should also print the total number of views to the terminal.
#The script should also print the total number of views to a file.

import csv
import sys
import requests
import json

# get the most popular videos on YouTube
def get_popular_videos(api_key):
    # set the base URL
    base_url = 'https://www.googleapis.com/youtube/v3/'
    # set the parameters
    params = {'part': 'snippet,contentDetails,statistics',
              'chart': 'mostPopular',
              'maxResults': '25',
              'key': api_key}
    # make the request
    response = requests.get(base_url + 'videos', params=params)
    # return the response
    return response.json()

# open a new file called 'report.csv' in write mode
with open('report.csv', 'w') as report_file:
    # create a csv writer object
    csv_writer = csv.writer(report_file)
    # write the header row
    csv_writer.writerow(['Title', 'Views', 'ID'])
    # get the API key from the command line
    api_key = sys.argv[1]
    # get the data
    data = get_popular_videos(api_key)
    # get the items
    items = data['items']
    # initialize the total views
    total_views = 0
    # iterate over the items
    for item in items:
        # get the video title
        video_title = item['snippet']['title']
        # get the video ID
        video_id = item['id']
        # get the number of views
        video_views = int(item['statistics']['viewCount'])
        # add to the total views
        total_views += video_views
        # write the row
        csv_writer.writerow([video_title, video_views, video_id])
    # write the total views
    csv_writer.writerow(['', '', ''])
    csv_writer.writerow(['Total Views', total_views, ''])

# open a new file called 'report.txt' in write mode
with open('report.txt', 'w') as report_file:
    # get the API key from the command line
    api_key = sys.argv[1]
    # get the data
    data = get_popular_videos(api_key)
    # get the items
    items = data['items']
    # initialize the total views
    total_views = 0
    # iterate over the items
    for item in items:
        # get the video title
        video_title = item['snippet']['title']
        # get the video ID
        video_id = item['id']
        # get the number of views
        video_views = int(item['statistics']['viewCount'])
        # add to the total views
        total_views += video_views
        # print the row
        print(video_title, video_views, video_id)
    # print the total views
    print('Total Views:', total_views)
    # write the total views
    report_file.write('Total Views: ' + str(total_views))