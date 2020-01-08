Source files for Jason K. Moore's EME 171 course.

Editing Guide
=============

- The website is built using Pelican. Review the `Pelican documentation`_ to
  get familar with how to create pages and articles.
- The source files are in the git branch called ``master``. This is the default
  branch of the repository. The HTML files are generated via doctr and pushed
  to the ``gh-pages`` branch, which is automatically seved to
  https://moorepants.github.io/eme171. You should not have to ever manually
  edit files in the ``gh-pages`` branch.
- All articles, pages, and similar content should be written in
  reStructuredText. See the `Sphinx reStructuredText primer`_ to learn the syntax.
- All changes, in general, should be submitted as Github pull requests. Don't
  commit directly to the ``master`` branch.
- Binary Assets such as images, videos, etc should be served from an external
  hosting site. Ask Jason about using his Dreamhost DreamObject bucket. He'll
  set it up for multi-user access when needed. Do not commit binary assets to
  this repository.
- You can edit and add rst files directly in the contents directory using the
  Github interface. The small pencil on files lets you edit and submit pull
  requests. Just above the directory view has buttons for adding files. See 
  these instructions: https://help.github.com/en/articles/editing-files-in-your-repository

.. _Pelican documentation: http://docs.getpelican.com/en/stable/
.. _Sphinx reStructuredText primer: http://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html

Building Locally
================

It is good practice to build the documentation locally so that you can review
change before submitting a pull request.

Install pelican with conda (or pip if you prefer)::

   $ conda install pelican

Clone the theme repository::

   $ git clone --branch mechmotum git@github.com:mechmotum/pelican-alchemy.git

Note the path to the theme, e.g.::

   /home/my_username/pelican-alchemy

Clone the pelican-plugins repository::

   $ git clone git@github.com:getpelican/pelican-plugins.git

Note the path to the plugins directory, e.g.::

   /home/my_username/pelican-plugins

Clone this repository and change into the new directory::

   $ git clone git@github.com:moorepants/eme171.git
   $ cd eme171/

Create a configuration file called ``config.yml`` and add the full path to
where you installed the theme::

   $ echo "THEME_PATH: /home/my_username/pelican-alchemy" > local-config.yml
   $ echo "PLUGIN_PATHS: /home/my_username/pelican-plugins" >> local-config.yml

Now you can build and serve the documentation with::

   $ make devserver

If this succeeds you can open the website in your web browser at
http://localhost:8000.

While the server is running you can change the website source files and they
will be build automatically. Refresh your web browser to view the changes.

To stop the web server press <CTRL + C> or type ``make stopserver``.

LICENSE
=======

This repository is licensed under the CC-BY 4.0 license.
