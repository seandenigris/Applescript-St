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
	#superclass : #Object,
	#traits : 'PeTPythonWrapper',
	#classTraits : 'PeTPythonWrapper classTrait',
	#instVars : [
		'id',
		'mailboxName',
		'accountID'
	],
	#category : #'Mac OSA-Core-Mail'
}

{ #category : #'as yet unclassified' }
OsaMacMailMessage class >> fromPythonInstance: pyInstance [

	^ self new
		pythonInstance: pyInstance;
		yourself
]

{ #category : #'as yet unclassified' }
OsaMacMailMessage class >> fromString: aString [

	| template |
	template := 'Application("Mail").accounts.byId("{accountID}").mailboxes.byName("{mailboxName}").messages.byId({ID})'.
	^ template format: {
		#ID -> self id asString.
		#mailboxName -> self mailboxName.
		#accountID -> self accountID } asDictionary.
]

{ #category : #testing }
OsaMacMailMessage class >> isClassFor: aString [

	^ 'Application\("Mail"\)\..*\.messages\.byId\(\d+\)' asRegex matches: aString
]

{ #category : #accessing }
OsaMacMailMessage >> accountID [
	^ accountID
]

{ #category : #accessing }
OsaMacMailMessage >> accountID: anObject [
	accountID := anObject
]

{ #category : #'as yet unclassified' }
OsaMacMailMessage >> appleScriptReferenceString [

	| template |
	template := 'first message of mailbox "{mailboxName}" of account id "{accountID}" of application "Mail" whose id is {ID}'.
	^ template format: {
		#ID -> self id asString.
		#mailboxName -> self mailboxName.
		#accountID -> self accountID } asDictionary.
]

{ #category : #'as yet unclassified' }
OsaMacMailMessage >> dateReceived [

	| isoString |
	"Date conversion adapted from https://stackoverflow.com/a/28147286"
	isoString := self newCommandFactory
		sourceWithResult: 'self.date_received().astimezone().isoformat()';
		sendAndWait.
		
	^ DateAndTime fromString: isoString 
]

{ #category : #'magritte-descriptions' }
OsaMacMailMessage >> dateReceivedDescription [
	<magritteDescription>
	
	^ MADateAndTimeDescription new
		accessor: #dateReceived;
		priority: 100;
		beReadOnly;
		yourself
]

{ #category : #'as yet unclassified' }
OsaMacMailMessage >> exported [

	| target |
	target := Tempfile named: self filenameForExport.
	target writeStreamDo: [ :str | str << self source ].
	^ target asRlResource
]

{ #category : #'as yet unclassified' }
OsaMacMailMessage >> filenameForExport [

	| base |
	base := (self dateReceived asFileNameCompatibleString, '_', self subject) asFilename first: 63.
	^ base, '.eml'
]

{ #category : #accessing }
OsaMacMailMessage >> id [
	^ id
]

{ #category : #accessing }
OsaMacMailMessage >> id: anObject [
	id := anObject
]

{ #category : #'as yet unclassified' }
OsaMacMailMessage >> jxaReferenceString [

	| template |
	template := 'Application("Mail").accounts.byId("{accountID}").mailboxes.byName("{mailboxName}").messages.byId({ID})'.
	^ template format: {
		#ID -> self id asString.
		#mailboxName -> self mailboxName.
		#accountID -> self accountID } asDictionary.
]

{ #category : #'as yet unclassified' }
OsaMacMailMessage >> jxaSourceWriteTo: aFileReference [

	OsaJavaScript do: 'const app = Application.currentApplication();
app.includeStandardAdditions = true;

var filePath = "', aFileReference fullName, '"; // Change this to your desired file path

const fileID = app.openForAccess(filePath,
    \{writePermission: true\});
app.write(', self string, '.source(), \{to: fileID\});
app.closeAccess(fileID);'
]

{ #category : #accessing }
OsaMacMailMessage >> mailboxName [
	^ mailboxName
]

{ #category : #accessing }
OsaMacMailMessage >> mailboxName: anObject [
	mailboxName := anObject
]

{ #category : #accessing }
OsaMacMailMessage >> sender [

	^ self newCommandFactory
		sourceWithResult: 'self.sender()';
		sendAndWait
]

{ #category : #'magritte-descriptions' }
OsaMacMailMessage >> senderDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		accessor: #sender;
		priority: 300;
		beReadOnly;
		yourself
]

{ #category : #'as yet unclassified' }
OsaMacMailMessage >> source [

	^ self newCommandFactory
		sourceWithResult: 'self.source()';
		sendAndWait
]

{ #category : #'magritte-descriptions' }
OsaMacMailMessage >> sourceDescription [
	<magritteDescription>
	
	^ MAMemoDescription new
		accessor: #source;
		priority: 400;
		lineCount: 20;
		beReadOnly;
		yourself
]

{ #category : #'GT Views' }
OsaMacMailMessage >> sourceGtViewFor: aView [
	<gtView>
	
	^ aView textEditor
		title: 'Source' translated;
		priority: 60;
		text: [ self source ]
]

{ #category : #'as yet unclassified' }
OsaMacMailMessage >> subject [

	^ self newCommandFactory
		sourceWithResult: 'self.subject()';
		sendAndWait
]

{ #category : #'magritte-descriptions' }
OsaMacMailMessage >> subjectDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		accessor: #subject;
		priority: 200;
		beReadOnly;
		yourself
]
