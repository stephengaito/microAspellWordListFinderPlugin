# Micro Find Aspell Personal Word List

A very simple [Micro Text Editor](https://micro-editor.github.io/) 
[plugin](https://micro-editor.github.io/plugins.html) which looks for 
[Aspell](http://aspell.net/) [personal word 
lists](http://aspell.net/man-html/Creating-an-Individual-Word-List.html#Creating-an-Individual-Word-List) 
in the current and any parent directories. 

The first personal word list found is then added to the Aspell arguments 
option, `aspell.args`, for the current buffer. 

This means that the [Micro Aspell 
plugin](https://github.com/priner/micro-aspell-plugin), if installed, will 
use the personal word list found by this plugin when the Aspell plugin 
checks the spelling of the current buffer. 

## Use case

By keeping an `.aspell.pws` text file in the root of your git 
repositories, you can keep any specialised words which are not in Aspell's 
main dictionaries in your repository's "personal word list". 

## Creating an empty personal word list

Type the following commands:

```
  echo "personal_ws-1.1 en 0" >  .aspell.pws
  echo                        >> .aspell.pws
```

## Suggested key bindings

Add the following to your ~/.config/micro/bindings.json file:

```
    "F5": "lua:aspell.acceptsug",
    "F6": "lua:aspell.addpersonal",
    "Tab": "Autocomplete|lua:aspell.acceptsug|IndentSelection|InsertTab"
``

## Notes:

1. Since the Aspell plugin might run before the AspellWordListFinder, when 
   you open up a buffer for the first time you *might* see words in your 
   personal word list marked as "misspelled"... if this is the case, 
   simply make a small change to the buffer and your personal word list 
   will be used from then on. 
   