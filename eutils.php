<?php

// Check to ensure this file is included in Joomla!
defined( '_JEXEC' ) or die( 'Restricted access' );

jimport( 'joomla.plugin.plugin' );
jimport( 'joomla.html.parameter' );
/**
* EUtils Content Plugin
*
*/
class plgContentEutils extends JPlugin
{

	/**
	* Constructor
	*
	* @param object $subject The object to observe
	* @param object $params The object that holds the plugin parameters
	*/
	function plgContentEutils( &$subject, $params )
	{
		parent::__construct( $subject, $params );
	}
		
	
	function onBeforeCompileHead()
	{ 	  		
		$document =& JFactory::getDocument();
		$document->addScript( 'plugins/content/eutils/js/angular.min.js' );
		$document->addScript( 'plugins/content/eutils/js/eutils.js' );
	} //end onBeforeCompileHead function 


} //end class
