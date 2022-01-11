//
//  Author: Hari Sekhon
//  Date: 2022-01-11 16:23:33 +0000 (Tue, 11 Jan 2022)
//
//  vim:ts=4:sts=4:sw=4:noet
//
//  https://github.com/HariSekhon/templates
//
//  License: see accompanying Hari Sekhon LICENSE file
//
//  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
//
//  https://www.linkedin.com/in/HariSekhon
//

// Copies a unix script to the local workspace and chmod's it to be used in a subsequent 'sh' step, eg:
//
//	steps {
//		loadScript('script.sh')
//		// or
//		// loadScript('script.sh', 'path/to/srcdir')
//	 	sh './script.sh ...'
//	}
//
// Alternatively, do what I do for my GitHub repos and use a git submodule or clone another repo locally to use its tools

def call(file, dir = '.') {
	def scriptContents = libraryResource "$dir/$file"
	writeFile file: "$file",
			  text: scriptContents
			  //encoding: "Base64"  # if the file is Base 64 encoded to decode it before writing (eg. for binaries)
	sh "chmod a+x ./$file"
}
