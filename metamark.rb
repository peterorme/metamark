#!/usr/bin/env ruby

# Metamark 
# (C) Peter Orme <peterorme6@gmail.com>
# Version 0.0.1
# 
# Metamark is a little script that indexes does an offline, on-demand indexing 
# of a github wiki. 

# The Drawer class is a simple multimap implementation. 
class Drawer
  attr_accessor :contents

  def initialize
    @contents = {}
  end     

  # Adds a key/value pair. If the key has another value already, the value is added 
  # to the list for that key.
  def add(key, val)
  	if @contents[key].nil?
  		@contents[key]=[val]
  	else
  		if !@contents[key].include?(val)
  			@contents[key].push(val)
  		end
  	end
  end 

  # Sets the value (or array) for a given key. 
  def set(key, arr)
  	if arr.kind_of?(Array)
  		@contents[key]=arr
  	else 
  		@contents[key]=[arr]
  	end
  end

  # removes a key and its values
  def delete(key)
  	@contents.delete(key)
  end

  # removes everything
  def clear
  	@contents.clear
  end

  # removes a specific key/value pair. If there are no more values for that key, 
  # the key is removed as well.
  def remove(key, val)
    if @contents[key].nil?
    	# already empty
  	else
  		if @contents[key].include?(val)
  			@contents[key].delete(val)
  			if @contents[key].empty?
  				puts "nothing left in #{key}"
  				@contents.delete(key)
  			end
  		end
  	end	
  end
end

# the Scanner finds .md files and looks for ~category:xxx directives.
# It collects them all in-memory, in the multimap, and then generates the 
# Cattegories.md file from the map.
class Scanner 

	attr_accessor :verbose

	def initialize
		@categories = Drawer.new
		@verbose = false
	end

	def add_cat(cat, filename)
		# clean the filename
		cat.strip! # This wasu unintentional, I swear. 
		pattern = /\.\/(.*)\.md/
		f = filename.match(pattern).captures[0]
		puts "Adding category #{cat}->#{f}" if @verbose
		@categories.add(cat, f)
	end

	# scan a single file
	def scanfile (filename)
		pattern = /^~[ ]?category:([[:alnum:][ _]]+)/

		puts "Scanning #{filename}" if @verbose

		f = File.open(filename, "r") 
		f.each_line do |line|
			# the "scan" is perhaps not right here. Optimize later. 
			cat = line.scan(pattern)
			# puts "SCAN #{line} -> #{cat}"
			if !cat.empty?
				match = cat[0][0]
				match.strip!
				add_cat(match, filename) if !match.empty?
			end
		end	
	end

	# Scan the folder for markdown files, and scan them
	def scanfolder(path)
		files = Dir[path]
		files.each do |file|
			scanfile(file)
		end
	end

	def dump
		print "DUMP: " 
		@categories.contents.each {|x| print x, " -- " }
		print "\n"
	end

	def write
		catfile = "Categories.md"

		File.open(catfile, 'w') { |file| 
			file.write("# Categories\n") 
			keys = @categories.contents.keys
			keys.sort!
			keys.each {|key|
				# heading: 
				file.write("\n\#\# #{key}\n")
				pages = @categories.contents[key].sort!
				pages.each {|page|
					file.write("* [#{page}](#{page})\n")
				}
			}
			now = Time.now()
			file.puts("\nGenerated by metamark on #{now}")
		}
	end
end

### Das Script An Sich

path = "./*.md"
scanner = Scanner.new
scanner.scanfolder(path)
scanner.write
puts "Metamark regenerated the Categories.md file."

