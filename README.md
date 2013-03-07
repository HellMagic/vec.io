VEC.IO
======

The source code for http://vec.io available!


Features
--------

1. Most powerful online Markdown editor on the earth, because I use CodeMirror and tweak it hardly!
2. An easy-to-use jQuery attachment uploader, integrated with CodeMirror Markdown editor.
3. Simple design for efficient reading and writing, focus on typography, without redundant functions.
4. Responsive design for all readers and writers with all kind of devices.
5. Editing history with diff, with pretty diff view to revert or delete.
6. Save drafts automaticlly with HTML5 local storage, also saved to server.
7. Every word is i18n ready, just need to change or add yml files.
8. Atom feed, automatic sitemap generator, and SEO optimization.


System requirements
-------------------

- Ruby 1.9.3+
- Pandoc 1.10+
- `sudo apt-get install mongodb memcached imagemagick trimage gifsicle jpegoptim libjpeg-progs optipng pngcrush`


How to deploy
-------------

1. `$ git clone https://github.com/vecio/vec.io.git`
2. `$ bundle`
3. Modify **db/seeds.rb**, **config/settings.yml**, **config/deploy.rb** and anything else you wanna.
4. `$ rake db:seed`
5. `$ rails s`
6. Test, test, test and make more modifications.
7. `$ cap deploy:setup`
8. `$ cap deploy`


LICENSE
-------

Copyright (c) 2012, Cedric Fung <cedric@vec.io>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the <organization> nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
