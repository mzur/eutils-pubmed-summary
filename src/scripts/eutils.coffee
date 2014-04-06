'use strict'

class EPS

	@_elementsAttribute = 'data-pubmed-summary'

	@_textPreamble = """
		<!-- Reference transferred from PubMed by eutils-pubmed-summary Version \
		2.0.0. https://github.com/mzur/eutils-pubmed-summary -->
	"""

	@_eUtilsUrl = (id) ->
		"https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&\
		id=#{id}"

	@_getId = (element) -> element.getAttribute @_elementsAttribute

	@_getData: (url, callback) ->
		request = new XMLHttpRequest()
		request.addEventListener 'load', (event) -> callback event.target
		request.open 'get', url
		request.send()

	@_getPubMed = (id, callback) ->
		wrapperCallback = (event) -> callback event.responseXML
		@_getData @_eUtilsUrl(id), wrapperCallback

	@_eval = (xml, xpath) ->
		result = xml.evaluate xpath, xml.documentElement, null,
			XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null
		if result is null
			[]
		else for i in [0...result.snapshotLength]
			result.snapshotItem(i).textContent

	@_evalAttr = (xml, attribute) ->
		@_eval xml, "//Item[@Name=\"#{attribute}\"]"

	@_getText = (xml) -> """
		#{@_textPreamble}
		#{@_evalAttr(xml, 'Author').join ', '} \
		(#{@_evalAttr(xml, 'PubDate')[0].split(' ')[0]})<br>\
		#{@_evalAttr(xml, 'Title')[0]}<br>#{@_evalAttr(xml, 'Source')[0]} \
		#{@_evalAttr(xml, 'Volume')[0]}(#{@_evalAttr(xml, 'Issue')[0]}): \
		#{@_evalAttr(xml, 'Pages')[0]}. <a href="http://www.ncbi.nlm.nih.gov/\
		pubmed?term=#{@_eval(xml, '//Id')[0]}" target="_blank">PubMed</a>
	"""

	@getElements: -> document.querySelectorAll "[#{@_elementsAttribute}]"