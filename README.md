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

## Deployment

To deploy the site:

```
bundle exec middleman deploy
```

###Note:

Using this workflow, you will work only in the source branch and *not touch* the gh-pages branch. Life is good.

***


If you find any of our documentation incomplete, please [file an issue](https://github.com/Sign2Pay/docs/issues) or submit a pull request.