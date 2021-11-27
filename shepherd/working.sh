#!/bin/bash
#curl -X POST   -H "Content-Type: application/json"   -d '{"username": "Shepherd", "embeds": [{"title": "Image Update", "color": 52224}]}'
#body="$(date) Service $name was updated from $previousImage to $currentImage"
#            curl -X POST -H "Content-Type: application/json" --data "{\"urls\":\"$notification_url\",\"title\": \"$title\", \"body\": \"$body\"}" "$apprise_sidecar_url"

tanggal=$(date)
author='AuthorName'
username='shepherd'
servicename='ampache_web:git'
title="Service $servicename updated"
previousImage='ampache_web@sha1'
currentImage='ampache_web@sha2'
body="body"
description="this is desc"
#body='{"username": "Shepherd", "embeds": [{"title": "Image Update", "color": 52224}]}'
#curl -X POST -H "Content-Type: application/json" --data "{\"urls\":\"$notification_url\",\"title\": \"$title\", \"body\": \"$body\"}" "$apprise_sidecar_url"
userid='Shepherd'
avatar_url='https://res.cloudinary.com/dedyms/image/upload/w_1000,c_fill,ar_1:1,g_auto,r_max,bo_5px_solid_red,b_rgb:262c35/v1616825895/container/919853_oscoe2.png'


apprise_sidecar_url="http://192.168.0.3:1000/notify"
notification_url='discord://816512109075628052/c2Dx2Kz9-rFfqAZ74Wei9Wa2zr8F3sMy0J2K9TVD3bMsxIZY2VQe3o33o0SIShIGa0oM'
#export body=""embeds": [{""Service ah was updated from A to B""}]"
#export title="title text"
#echo $body;
#echo $date;
#curl -X POST -H "Content-Type: application/json" -d '{"username": "'$username'", "embeds": [{"title": "Service '$servicename' updated", "color": 52224, "description": "Service '$servicename' was updated from '$previousImage' to '$currentImage'"}]}' "$notification_url"
#curl -X POST -H "Content-Type: application/json" --data "{\"urls\":\"$notification_url\",\"title\": \"$title\", \"body\": \"$body\"}" "$caronc"

#curl -X POST -H "Content-Type: application/json" --data "{\"urls\":\"$notification_url\"\?\"userid\"\=\"$userid\"&\"avatar_url\"=\"$avatar_url\",\"title\": \"$title\", \"body\": \"$body\"}" "$caronc"
#combine="$notification_url/?user=$userid&avatar_url=$avatar_url&format=markdown&footer=no"
#app_id="lele"
#echo $combine
#curl -X POST -H "Content-Type: application/json" --data "{\"urls\":\"$combine\",\"title\": \"$title\", \"body\": \"$body\"}" "$caronc"

title="Schedule started"   
body="Scanning service\n$(date +%a,\ %d\ %b\ %Y\ -\ %R:%S\ %Z)"
notification_url_avatar="$notification_url/?avatar_url=$avatar_url&user=$userid&format=markdown&app_id=Homelab"
curl -X POST -H "Content-Type: application/json" --data "{\"urls\":\"$notification_url_avatar\",\"title\": \"$title\", \"body\": \"$body\"}" "$apprise_sidecar_url"
#echo $notification_url_avatar;
