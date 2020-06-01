# Applescript-St
Communicate with Mac scriptable applications from within Pharo. 

In a perfect world, this would mean accessing script objects as seemlessly as from within AppleScript (AS), but with the full power of Pharo's IDE. In reality, Apple Automation seems to be an absolute mess, making AS-like libraries in other languages problematic. Therefore, the easiest approach is to write scripts in AS (I know yuck) and at least be able to *run* then in Pharo. This is the minimum basic feature we provide. That said, providing something like rb-appscript, which allows AS-like Ruby code (e.g. `all_names = Appscript.app("Finder").files.name.get`) is a long-term dream. 

## Future
Given that Applescript [seems to be dying](https://eclecticlight.co/2016/11/18/goodbye-applescript/), and maybe so is Mac Automation in general (see [here](https://eclecticlight.co/2017/07/23/last-week-on-my-mac-withering-automation/) and [here](https://www.computerworld.com/article/3142666/does-apple-really-want-to-kill-automator-applescript.html)), it’s unclear whether significant additional investment in Apple Events makes sense. 

Hamish Sanderson has offered some brutal critiques on Apple’s failure to properly invest and deliver on Automation in general. While he seems to have finally given up on Mac Automation, his previous position seemed to be that: “the most reliable way for Objective-C applications to send Apple events is to call AppleScript handlers directly via the AppleScript-Objective-C bridge”. Prior to that, he had himself started - and seemingly abandoned - several attempts to overcome these deficits, including:
- Appscript, which was ported to Python, Ruby, and Objective-C. The [original repo](https://sourceforge.net/projects/appscript/) was on sourceforge. While it’s said to be abandoned years ago, there are some commits from 2019. Also, Matt Neuberg put the code [on GitHub](https://github.com/mattneub/appscript), and there are at least [a few forks](https://github.com/poulsbo/appscript) that put some commits into updating it.
- [AppleEventBridge](https://bitbucket.org/hhas/appleeventbridge/src/master/) is "a modernized, reworked fork of the objc-appscript bridge.” However, “further development has been discontinued in favor of the SwiftAutomation framework… therefore its use is not recommended.”
- [SwiftAutomation framework](https://bitbucket.org/hhas/swiftae) "is an Apple event bridge that allows Apple's Swift language to control ‘AppleScriptable’ macOS applications directly", but “given current uncertainty regarding the future of Apple event-based automation the project is on hiatus until WWDC17”. While Hamish’s later comments suggest he’s given up, there are commits here too from 2019.
- [Entoli](https://bitbucket.org/hhas/entoli/src/master/README.txt) - "An experimental end-user language design, stealing ideas on semantic simplicity and syntactic friendliness from Logo and AppleScript respectively, while also [hopefully] avoiding their various pitfalls and errors.” While interesting, it’s not clear how this fits into the Automation picture.

## History
- 2011-12-06 Applescript plugin broken in Cog Jit Cocoa VMs; this project is created to restore some AS-support
- 2016-08-20 Migrated from http://ss3.gemstone.com/ss/SimpleApplescript.html
