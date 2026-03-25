# Plex

A self hosted plex server for home videos.

## Configuration

### File System
Create the following mounted folders or connect a drive with your data.
- `/pwspoola/plex/tvseries`
- `/pwspool/archive/plex/movies`
- `/pwspool/archive/plex/photos`
- `/pwspool/archive/plex/homevideos`
- `/pwspool/archive/plex/transcode`
- `/pwspool/archive/plex/downloads`

### Downloads Configuration
Requires that the `/transcode` and `/downloads` directories are created and linked.
1. Configure `Settings > Transcoder > Transcoder Temporary Directory` = `/transcode` mount on container.
2. Configure `Settings > Transcoder > Downloads Temporary Directory` = `/downloads` mount on container.
3. Configure `Settings > Network > Custom Server Access URLs` to be a CSV of locations to access through.
- For local this is `http://192.168.1.XXX:32400`, for prod this is the domain. You can specify both.
- Example: `http://192.168.1.135:32400,https://watch.whitney.rip`
4. Configure `Settings > Remote Access > Manually specify public port` = `32400` to ensure direct connections work when UPnP is unavailable.

## Setup
When navigating to plex, assuming no nginx routing is happening, you must go to `https://[url]/web/index.html#!/` for first time setup.

