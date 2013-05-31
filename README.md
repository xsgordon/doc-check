Author: Stephen Gordon <sgordon@redhat.com>
Date: 16th March 2011
Last Update: 24th March 2011

Purpose:
========

Runs a number of simple checks on DocBook XML files and displays errors/or
warnings indicating the results. Checks include:

* Spelling.
* Repeated words ('the the', etc.).
* Informal contractions.

The script is able to operate either on a single DocBook XML file or on
an entire Publican (http://fedorahosted.org/publican) book.

Prerequisites:
==============

This fairly simple bash script relies on the presence of the following binaries:

*grep*	- Expected location is /bin/grep
*sort*	- Expected location is /bin/sort
*aspell*  - Expected location is /usr/bin/aspell

If the above binaries are not already available on the system then they must be
installed. Alternatively if they are available on the system but not in the
above locations then the environment variables set in the script must be
updated manually.

Usage:
======

qa_check.sh - Run from the root directory of a DocBook XML book (where
publican.cfg resides).

qa_check.sh /path/to/myxmlfile.xml - Check a single file.

Change Log:
===========

16th March 2011    - Initial version committed.
24th March 2011	   - Improved repetition check.
21st April 2011    - Added support for scanning a single xml file.
28th November 2011 - Added support for contraction detection.
31st May 2013      - Moved to github.
