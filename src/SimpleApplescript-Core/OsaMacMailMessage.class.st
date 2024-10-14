"
I'm based on JXA because AppleScript references to mail messages cannot be used in a straightforward way. There turned out to be a seemingly simple fix, but the die had been cast. If we ever want to explore via AS, one has to convert a reference like this:
```applescript
message id 1 of mailbox ""INBOX"" of account id ""1234"" of application ""Mail""
```
to this:
```applescript
first message of mailbox ""INBOX"" of account id ""1234"" of application ""Mail"" whose id is 1
```

I asked why this more convoluted form is needed [on StackOverflow](https://stackoverflow.com/q/79084511)

With AS, osascript does not encode newlines as \n so seemingly would be more straightforward to use to export messages.
"
Class {
	#name : #OsaMacMailMessage,
	#superclass : #OsaJavaScriptReference,
	#category : #'SimpleApplescript-Core-Mail'
}

{ #category : #testing }
OsaMacMailMessage class >> isClassFor: aString [

	^ 'Application\("Mail"\)\..*\.messages\.byId\(\d+\)' asRegex matches: aString
]

{ #category : #'as yet unclassified' }
OsaMacMailMessage >> exported [

	| target |
	target := Tempfile named: self filenameForExport.
	self sourceWriteTo: target.
	^ target asRlResource
]

{ #category : #'as yet unclassified' }
OsaMacMailMessage >> filenameForExport [

	^ (self dateReceived asFileNameCompatibleString, '_', self subject) asFilename, '.eml'
]

{ #category : #'as yet unclassified' }
OsaMacMailMessage >> sourceWriteTo: aFileReference [

	OsaJavaScript do: 'const app = Application.currentApplication();
app.includeStandardAdditions = true;

var filePath = "', aFileReference fullName, '"; // Change this to your desired file path

const fileID = app.openForAccess(filePath,
    \{writePermission: true\});
app.write(', self string, '.source(), \{to: fileID\});
app.closeAccess(fileID);'
]
