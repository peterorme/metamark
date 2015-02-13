# Metamark 0.0.1

## What is Metamark? 

Metamark is 

1. A method of adding some rudimentary indexing of text files, primarily intended for github wiki pages, and

2. A Ruby script that scans a folder for markdown files, looking for special markup, and creating stuff from that.

## How to use it

The idea is that you just create a wiki in a github project. Just set up a github project and click the "wiki" link and start creating pages. Or maybe you have already done this, but you want to categorize them automatically. 

In the markdown files themselves, just add the ~category directive (see below). The github wiki is a github repo in itself. Clone this. Drop in the metamark.rb script in the root of the wiki repo. Run it. It generates a Categories.md file. Commit it and push it back to master on the wiki. It should show up in the wiki, and contain links back to the categorized pages.  

## Metamark markdown

### The Category Directive  

To say that a page belongs in a category (let's say, 'Animals'), add this to a line on its own in that document, first on a line: 
	
	~ category:Animals

Categories may contain letters, numbers and spaces. A page can be added to any number of categories, just add multiple ~categories lines.

### Running the Metamark script 

Run the metamark ruby file. On OS X: 

	./metamark.rb

it will generate the Categories.md file, with a heading for each category, and bullet points back to the files. 

### Installation (Linux and OS X)

You will need to have Ruby installed. 

I am on OS X so I just do `chmod +x *.rb` and then I can just run `./metamark.rb`. I have Ruby version 2 dot something. OK, it's 2.0.0p451. 

### Installation (Windows)

I'm not sure this works on Windows, but I guess it should. You will still need to have Ruby installed, and run the metamark.md script somehow. Maybe `ruby metamark.rb` works. If anybody knows let me know. 

This is not very fancy, but slightly better than nothing. 

### Version history

0.0.1. First version in the wild. "Probably buggy as hell". 

