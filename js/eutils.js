angular.module('eutils.summary', [])
	.config(function($httpProvider){
		// for enabling cross-domain request
		delete $httpProvider.defaults.headers.common['X-Requested-With'];
	})
	.directive('pubmedSummary', function($http) {
		return {
			restirct: "A",

			scope: true,

			template: "<!-- Reference transferred from PubMed by the Joomla EUtils Plugin Version 1.2.0 -->" +
				"<span data-ng-bind-html-unsafe=\"authors\"></span> ({{date}})<br/>{{title}}<br/>" +
				"{{journal}} {{volume}}({{issue}}): {{pages}}. " +
				"<a href=\"http://www.ncbi.nlm.nih.gov/pubmed?term={{id}}\" target=\"_blank\">PubMed</a>",

			link: function($scope, $elm, $attrs) {
				var BASE_URL = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi'
				var DB = 'db=pubmed';
				var ID = 'id=' + $attrs.pubmedSummary;
				var highlight = $attrs.pubmedHighlight;

				var highlightAuthor = function(author) {
					if (author.toLowerCase().indexOf(highlight.toLowerCase()) !== -1) {
						return '<b>' + author + '</b>';
					}
					return author;
				}

				var processAutors = function(authors) {
					if (highlight === undefined) return authors;
					return authors.map(highlightAuthor);
				}

				var getContent = function(xml, xpath) {
					var ret = [];
					var result = xml.evaluate(xpath, xml.documentElement, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
					if (result == null) return ret;
					for (var i = 0, len = result.snapshotLength; i < len; i++) {
						ret.push(result.snapshotItem(i).textContent);
					}
					return ret;
				}

				var success = function(data) {
					var xml = new DOMParser().parseFromString(data, 'text/xml');

					var authors = getContent(xml, '//Item[@Name="Author"]');
					$scope.authors = processAutors(authors).join(', ');
					$scope.date = getContent(xml, '//Item[@Name="PubDate"]')[0].split(' ')[0];
					$scope.title = getContent(xml, '//Item[@Name="Title"]')[0];
					$scope.journal = getContent(xml, '//Item[@Name="Source"]')[0];
					$scope.volume = getContent(xml, '//Item[@Name="Volume"]')[0];
					$scope.issue = getContent(xml, '//Item[@Name="Issue"]')[0];
					$scope.pages = getContent(xml, '//Item[@Name="Pages"]')[0];
					$scope.id = getContent(xml, '//Id')[0];
				}

				$http.get(BASE_URL + '?' + DB + '&' + ID).success(success);
			}
		};
	});

window.onload = function() {
	var apps = document.getElementsByClassName('eutils-summary');
	for (var i = apps.length - 1; i >= 0; i--) {
		angular.bootstrap(apps[i], ['eutils.summary']);
	};
}