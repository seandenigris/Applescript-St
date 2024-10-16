Extension { #name : #ByteString }

{ #category : #'*Mac OSA-Core' }
ByteString >> asAppleScript [
	"Literal quotes in an Applescript string must be escaped (see https://stackoverflow.com/a/10668503/424245)"
	^ self copyReplaceAll: '"' with: '\"'.
]
