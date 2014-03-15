## Fiasco: a minimalistic, script based video editor using ffmpeg

**Fiasco** is a minimalistic scripting language used for quickly putting together
videos, using the FFMpeg encoder. Its main purpose is creating a 
layer of abstraction over the powerful but complex syntax of
FFMpeg, giving a set of basic operations commonly used in video editing.

Fiasco is written in Perl and released under the very liberal 
MIT license. Any contribution is permitted, and, in fact, encouraged.

A recent installation or executable of FFMpeg is required.
Tested on Windows only currently. All codecs and containers
that FFmpeg can work with are supported (this means a lot). 

Usage:

    fiasco [script file] [output video]

Syntax for script file:

    path\to\video.avi start_time end_time

Example:

	Videos\funny.avi 12 23
    STUFF\birthday.mov 00:01:30 00:03:20
    video.mkv 00:02:30.342 00:02:40.354
	youtube.flv 1 00:00:23.213

Fiasco will automate the process of extraction, conversion and 
conjunction of all the segments defined in the file. 
Be careful to not add spaces in names of the videos/directories. 
(hopefully will be fixed soon).

The syntax for start_time and end_time time can either be:
* Number of seconds from start of video
* Timestamp in the format HH:MM:SS or HH:MM:SS.mmm

You can see an example of the syntax in the file videos.txt 

### TODOS
* Add support for output file format
* Add support for superfast (preview) mode
* Make parsing of files better
