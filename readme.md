
 Introduction
----------------

I usually have a lot of different bash scripts lying around and I felt it might 
be a good idea to put them in one place together so I can more easily expand and 
improve my script code base.

The `vendor` directory contains git submodules to third-party code. To use this 
functionality you will need to initialize these submodules. This can be done 
with the following command:

    git submodule init && git submodule update

I also have a *very* basic installer for my `.bashrc` and `.gitconfig` files 
(use at your own risk).

 `.bashrc` `.bash_aliases` and `bashrc.d`
----------------

I prefer, instead of editing `.bashrc`, to put any changes I like for the prompt 
in `.bash_aliases`. Anything more complex than a single (or a couple) of lines I 
put in `.bashrc.d` and include from `.bash_aliases`. The `.bashrc.d` directory also 
contains a file to include vendor scripts from the submodules in the `vendor` 
directory.

 `.gitconfig` and `git.d`
----------------

 My git config file has some aliases, some nice colours and some handy additions.

 `svn.d`
----------------

Thankfully I no longer have to work with SVN for my personal of professional 
projects. This directory contains some SVN related scripts from when I did.

 `functions`
----------------

To save myself some time I tend to re-use what I can. Simple functions go here.

 `util.d`
----------------

Random collection of utility scripts. Need a lot of tidying-up. 

 About the name...
----------------

![Sandurz][sandurz_img]


[sandurz_img]: sandurz.png  "Prepare ship for ludicrous speed! Fasten all seatbelts, seal all entrances and exits, close all shops in the mall, cancel the three ring circus, secure all animals in the zoo!"

--EOF--
