# Cat Herd
## Being a collection of programs producing the basic behavior of cat(1)

It came to my attention long ago that it was useful to have scripts which did simple transformations to files or various output,
and that these situations all had a simple flow: input-> munging-> output. Moreover, it was clear that a basic regular expression search and replace mechanism worked just fine.

I built myself a nice little script with my fave language at the time: *Perl*. It wasn't as clever as cat(1), but it didn't need to be.

I used this a fair amount on my job. Then one day I decided I ought to learn *Python*, and having read through a good book on it, and wrote a version in this language.

It occurred to me that this was a far better test of a language that the universally used "Hello, World!", in which you rarely have to set variables or call libraries, much less write functions or classes.

Thus, every so often when I'm learning a language, I try and write cat in it.

These are the ones I've kept.

You are welcome to submit your own for fun, assuming you are okay with the MIT license, i.e. free for whatever, but keep your attribution.

These are best used as a skeleton for making file filters, in the tradition of Unix.

### Requirements

1. Must take a stream of data, either from a file, or STDIN, and redirect it to another file, or STDOUT.
2. Must take parameters via the commandline:
  -f filein, for the input file,
  -o fileout for the output file,
  -v to print the version,
  -h to print the version and a Usage statement.
  The usage statement should be a complete manual.
3. Must have a basic filter capability: given a regexp, only matching lines should be able to pass through.

### Test cases
1. "cat /etc/printcap | pycat" should produce the printcap file
2. "cat /etc/printcap | pycat -v" should produce only the version string, ignoring the attempted input
3. pycat -f /etc/printcap" should produce the same as 1 or "cat /etc/printcap"
4. pycat -h should print a usage message
5. pycat -f /etc/printcap -o /tmp/printcarp should produce a copy of /etc/printcap into the file /etc/printcarp
6. pycat -f /etc/printcap -r "^indust" should only print those lines beginning with "indust"
7. Same as above, but with -nr (negate regexp) will print those lines NOT beginning with "indust"


* One day, my versions might even do all that.
