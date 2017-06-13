# ExmlTranslator

** SAX-based XML files translator with Google Translator **

** You will need Google API key, go to Google Console **

** NOT COVERED WITH TESTS, DO NOT USE IN PRODUCTION **


## Installation

Not available in Hex by far.


## How to use

```
ExmlTranslator.run("test.xml", "", "", "")
# I didnt make this configurable yet, locale and output filename are hardcoded.
# Open and edit this:
# def locale(), do: "de"
# def out_filename(), do: "output.xml"
```
