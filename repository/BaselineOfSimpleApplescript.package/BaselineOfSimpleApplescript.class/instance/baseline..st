baseline
baseline: spec
	<baseline>
	spec
		for: #common
		do: [
			spec
				baseline: 'PharoEnhancements' with: [
					spec repository: 'github://seandenigris/Pharo-Enhancements' ];
				project: 'OSProcess'
				with: [ spec
						className: 'ConfigurationOfOSProcess';
						loads: #('Core with Output');
						versionString: #stable;
						repository: 'http://www.squeaksource.com/MetacelloRepository' ].
			spec
				package: 'SimpleApplescript-Core'
					with: [ spec requires: #('OSProcess' 'PharoEnhancements') ];
				package: 'SimpleApplescript-Specification'
					with: [ spec requires: #('SimpleApplescript-Core') ].
			spec group: 'Core' with: #('SimpleApplescript-Core') ]