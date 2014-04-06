'use strict'

describe 'eutils pubmed summary', ->

	xml = null

	beforeEach ->
		document.body.innerHTML = __html__['test/test-element.html']
		xml = null
		callback = (d) ->	xml = d.responseXML
		runs -> EPS._getData 'http://localhost:9875/base/test/esummary.xml', callback
		waitsFor -> xml isnt null

	describe 'the EPS object', ->

		describe 'getElements function', ->

			it """
				should return all elements of the document, that have the\
				\ "data-pubmed-summary" attribute
			""", ->
				expect(EPS.getElements().length).toEqual 3

		describe '_eUtilsUrl function', ->

			it 'should assemble the query url with the given PubMed ID', ->

				expect(EPS._eUtilsUrl '20541552').toBe """
					https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?\
					db=pubmed&id=20541552
				"""

		describe '_getData function', ->

			it 'should pass the received data to the callback function', ->
				data = null
				callback = (d) ->	data = d
				runs -> EPS._getData 'http://localhost:9875/base/test/small.xml', callback

				waitsFor -> data isnt null

				runs -> expect(data.responseText).toBe """
					<?xml version="1.0" encoding="UTF-8"?>
					<xml>
					</xml>
				"""

		describe '_eval function', ->

			it 'should return an empty array of no nodes matched the xpath', ->
				result = EPS._eval xml, '//Item[@Name="Sauce"]'
				expect(result).toEqual []

			it 'should return an array of the text content of the matched nodes', ->
				result = EPS._eval xml, '//Item[@Name="Source"]'
				expect(result).toEqual ['FEBS Lett']

		describe '_evalAttr function', ->

			it """
				should evaluate the xml with only the node attribute value as argument
			""", ->
				expect(EPS._evalAttr xml, 'Source').toEqual ['FEBS Lett']

		# describe '_getPubMed function', ->

		# 	it """
		# 		should pass the pubmed eutils xml specified by the id to the callback
		# 	""", ->
		# 		xml = null
		# 		callback = (d) ->	xml = d
		# 		runs -> EPS._getPubMed '20541552', callback

		# 		waitsFor -> xml isnt null

		# 		expect(EPS._evalAttr xml, 'Source').toEqual ['FEBS Lett']


		describe '_getText function', ->

			it 'should return the correctly formatted text to insert in the node', ->
				text = EPS._getText xml
				expect(text).toBe """
				<!-- Reference transferred from PubMed by eutils-pubmed-summary \
				Version 2.0.0. https://github.com/mzur/eutils-pubmed-summary -->
				Appelhagen I, Huep G, Lu GH, Strompen G, Weisshaar B, Sagasser M \
				(2010)<br>Weird fingers: functional analysis of WIP domain proteins.\
				<br>FEBS Lett 584(14): 3116-22. <a href="http://www.ncbi.nlm.nih.\
				gov/pubmed?term=20541552" target="_blank">PubMed</a>
				"""
		
		describe '_getId', ->

			it """
				should return the PubMed ID specified in the attribute of an element
			""", ->
				element = document.createElement 'p'
				element.setAttribute 'data-pubmed-summary', '20541552'
				expect(EPS._getId element).toBe '20541552'
				