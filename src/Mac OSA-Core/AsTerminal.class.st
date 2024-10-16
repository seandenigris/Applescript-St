Class {
	#name : #AsTerminal,
	#superclass : #Object,
	#category : #'Mac OSA-Core'
}

{ #category : #preferences }
AsTerminal class >> changeFontSize [
	<script>
	Smalltalk tools webBrowser new open: 'https://apple.stackexchange.com/a/246281/9507' asUrl
	
	
]

{ #category : #API }
AsTerminal >> activate [
	^ self tellTo: 'activate'
]

{ #category : #API }
AsTerminal >> doScript: aCommand [

	| scriptTemplate tellScript |
	scriptTemplate := 'do script "{script}"'.
	tellScript := scriptTemplate format: { #script -> aCommand asAppleScript } asDictionary.
	^ self tellTo: tellScript
]

{ #category : #API }
AsTerminal >> tellTo: aCommand [

	^ OsaScript new tell: 'Terminal' to: aCommand
]
