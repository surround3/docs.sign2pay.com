# docs.sign2pay.com

This is the source for [docs.sign2pay.com](http://docs.sign2pay.com).


## Middleman

These docs are now generated using the excellent [Middleman Framework](https://middlemanapp.com).

## Installation

To install this locally:

```
bundle
```

## Development

The main branch for docs is ```source```.  We work locally using HAML (layouts and partials), SCSS, COFFEESCRIPT. These are served, along with livereload during dev via the Middleman server To start the server:

```
bundle exec middleman server
```

Done with edits?  Don't forget to update the remote source branch ```git push origin source```.

## Deployment

To deploy the site:

```
bundle exec middleman deploy
```

> Make sure you call this from ```source``` folder and DELETE your local build directory FIRST!

Middleman deploy will not work if you're signing your commits with GPG since it won't be able to use your key. So disable that first:

```
git config --global commit.gpgsign false
```

and reenable after:

```
git config --global commit.gpgsign true
```

###Note:

Using this workflow, you will work only in the source branch and *not touch* the gh-pages branch. Life is good.

***


If you find any of our documentation incomplete, please [file an issue](https://github.com/Sign2Pay/docs/issues) or submit a pull request.
