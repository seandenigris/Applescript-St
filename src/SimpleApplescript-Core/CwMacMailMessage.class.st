Class {
	#name : #CwMacMailMessage,
	#superclass : #OsaJavaScriptReference,
	#category : #'SimpleApplescript-Core'
}

{ #category : #testing }
CwMacMailMessage class >> isClassFor: aString [

	^ 'Application\("Mail"\)\..*\.messages\.byId\(\d+\)' asRegex matches: aString
]

{ #category : #'as yet unclassified' }
CwMacMailMessage >> sourceWriteTo: aFileReference [

	OsaJavaScript do: 'const app = Application.currentApplication();
app.includeStandardAdditions = true;

var filePath = "', aFileReference fullName, '"; // Change this to your desired file path

const fileID = app.openForAccess(filePath,
    \{writePermission: true\});
app.write(', self string, '.source(), \{to: fileID\});
app.closeAccess(fileID);'
]
