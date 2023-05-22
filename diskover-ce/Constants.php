<?php
/*
diskover-web community edition (ce)
https://github.com/diskoverdata/diskover-community/
https://diskoverdata.com

Copyright 2017-2021 Diskover Data, Inc.
"Community" portion of Diskover made available under the Apache 2.0 License found here:
https://www.diskoverdata.com/apache-license/

All other content is subject to the Diskover Data, Inc. end user license agreement found at:
https://www.diskoverdata.com/eula-subscriptions/

Diskover Data products and features for all versions found here:
https://www.diskoverdata.com/solutions/

*/

// diskover-web community edition (ce) sample/default config file

namespace diskover;

class Constants {
    // set to your local time zone https://www.php.net/manual/en/timezones.php
    // override with env var TZ
    const TIMEZONE = 'Asia/Jakarta';
    // Elasticsearch host/ip config
    // if you are using AWS ES set host to your Elasticsearch endpoint without http:// or https://
    // override with env var ES_HOST
    const ES_HOST = 'es';
    // default port for Elasticsearch is 9200 and AWS ES is 80 or 443
    // override with env var ES_PORT
    const ES_PORT = 9200;
    // for no username and password set ES_USER and ES_PASS to ''
    // override with env vars ES_USER and ES_PASS
    const ES_USER = 'elastic';
    const ES_PASS = 'changeme';
    // if your Elasticsearch cluster uses HTTP TLS/SSL, set ES_HTTPS to TRUE
    // override with env var ES_HTTPS
    const ES_HTTPS = FALSE;
    // login auth for diskover-web
    const LOGIN_REQUIRED = TRUE;
    // username and password to login
    const USER = 'diskover';
    const PASS = 'darkdata';
    // if your Elasticsearch cluster uses HTTP TLS/SSL, set ES_HTTPS to TRUE
    // override with env var ES_HTTPS
    const ES_HTTPS = FALSE;
    // Elasticsearch SSL Verification
    // set to TRUE (default) to verify SSL or FALSE to not verify ssl when connecting to ES
    // override with env var ES_SSLVERIFICATION
    const ES_SSLVERIFICATION = TRUE;

    // default results per search page
    const SEARCH_RESULTS = 50;
    // default size field (size, size_du) to use for sizes on charts
    const SIZE_FIELD = 'size';
    // default file types, used by quick search (file type) and dashboard file type usage chart
    // additional extensions can be added/removed from each file types list
    const FILE_TYPES = [
        'docs' => ['doc', 'docx', 'odt', 'pdf', 'tex', 'wpd', 'wks', 'txt', 'rtf', 'key', 'odp', 'pps', 'ppt', 'pptx', 'ods', 'xls', 'xlsm', 'xlsx'],
        'images' => ['ai', 'bmp', 'gif', 'ico', 'jpeg', 'jpg', 'png', 'ps', 'psd', 'psp', 'svg', 'tif', 'tiff', 'exr', 'tga'],
        'video' => ['3g2', '3gp', 'avi', 'flv', 'h264', 'm4v', 'mkv', 'qt', 'mov', 'mp4', 'mpg', 'mpeg', 'rm', 'swf', 'vob', 'wmv', 'ogg', 'ogv', 'webm'],
        'audio' => ['au', 'aif', 'aiff', 'cda', 'mid', 'midi', 'mp3', 'm4a', 'mpa', 'ogg', 'wav', 'wma', 'wpl'],
        'apps' => ['apk', 'exe', 'bat', 'bin', 'cgi', 'pl', 'gadget', 'com', 'jar', 'msi', 'py', 'wsf'], 
        'programming' => ['c', 'cgi', 'pl', 'class', 'cpp', 'cs', 'h', 'java', 'php', 'py', 'sh', 'swift', 'vb'],
        'internet' => ['asp', 'aspx', 'cer', 'cfm', 'cgi', 'pl', 'css', 'htm', 'html', 'js', 'jsp', 'part', 'php', 'py', 'rss', 'xhtml'],
        'system' => ['bak', 'cab', 'cfg', 'cpl', 'cur', 'dll', 'dmp', 'drv', 'icns', 'ico', 'ini', 'lnk', 'msi', 'sys', 'tmp', 'vdi', 'raw'],
        'data' => ['csv', 'dat', 'db', 'dbf', 'log', 'mdb', 'sav', 'sql', 'tar', 'xml'],
        'disc' => ['bin', 'dmg', 'iso', 'toast', 'vcd', 'img'],
        'compressed' => ['7z', 'arj', 'deb', 'pkg', 'rar', 'rpm', 'tar', 'gz', 'z', 'zip'],
        'trash' => ['old', 'trash', 'tmp', 'temp', 'junk', 'recycle', 'delete', 'deleteme', 'clean', 'remove'] 
    ];
    // extra fields for search results and view file/dir info pages
    // key is description for field and value is ES field name
    // Example:
    //const EXTRA_FIELDS = [
    //    'Date Changed' => 'ctime'
    //];
    const EXTRA_FIELDS = [];
    // Maximum number of indices to load by default, indices are loaded in order by creation date
    // setting this too high can cause slow logins and other timeout issues
    // This setting can bo overridden on indices page per user
    const MAX_INDEX = 250;
    // time in seconds for index info to be cached, clicking reload indices forces update
    const INDEXINFO_CACHETIME = 600;
    // time in seconds to check Elasticsearch for new index info
    const NEWINDEX_CHECKTIME = 10;
    const DATABASE = '../database/diskoverdb.sqlite3';

}
