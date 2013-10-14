eutils-pubmed-summary
=====================

A Joomla! 3 plugin for including automatically generated summaries of PubMed articles.

## Installation

Get the latest release and install it using the Joomla Extension Manager. After that activate the "EUtils PubMed" plugin.

## Usage

The plugin works as [http://angularjs.org/](AngularJS) directive. To invoke the directive, add the CSS class ```eutils-summary``` to the HTML element that should contain the summary or summaries respectively. To create a summary add the ```pubmed-summary="ID"``` attribute either to the prevously mentioned element or to a new child element, where ```ID``` is the PubMed ID of the article.

### Author highlighting

To select an author for highlighting, add ```pubmed-highlight="NAME"``` where ```NAME``` is the name the author (or part of it). If there are multiple authors matching ```NAME``` all are highlighted, so you have to choose a more specific ```NAME```. The highlighting is displayed as bold text.

## Examples

### List

```html
<ul class="eutils-summary">
  <li data-pubmed-summary="20541552"></li>
  <li data-pubmed-summary="20107808"></li>
  <li data-pubmed-summary="11782451"></li>
</ul>
```

### Paragraphs
```html
<section class="eutils-summary">
	<p data-pubmed-summary="20541552"></p>
	<p data-pubmed-summary="20107808"></p>
	<p data-pubmed-summary="11782451"></p>
</section>
```

### Multiple Directives

```html
<p class="eutils-summary" data-pubmed-summary="20541552"></p>
<p class="eutils-summary" data-pubmed-summary="20107808"></p>
<p class="eutils-summary" data-pubmed-summary="11782451"></p>
```


### Author highlighting

```html
<p class="eutils-summary" data-pubmed-summary="20541552" data-pubmed-highlight="appelhagen"></p>
```

## Issues

This plugin uses modern technologies such as JavaScript XML parsing, XPath or AngularJS. It is not developed for high compatibility of old browsers or Internet Explorer.