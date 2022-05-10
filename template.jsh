#!/usr/bin/env java --source 11
//
//  Author: Hari Sekhon
//  Date: 2019-11-28 15:50:07 +0000 (Thu, 28 Nov 2019)
//
//  https://github.com/HariSekhon/Templates
//
//  License: see accompanying Hari Sekhon LICENSE file
//
//  If you're using my code you're welcome to connect with me on LinkedIn
//  and optionally send me feedback to help improve or steer this or other code I publish
//
//  https://www.linkedin.com/in/HariSekhon
//

// Requires Java 11
//
// suffix extension must not end in .java for first shebang line to be correctly discarded

import java.io.File;
import java.net.URISyntaxException;
import java.security.CodeSource;
import java.io.IOException;
import java.util.stream.Stream;
import java.io.BufferedReader;
import java.io.InputStreamReader;

public class MyMain {

    public static void main(String[] args) throws URISyntaxException, IOException {

        //System.out.println(System.getProperty("java.class.path"));

        //String prog = MyMain.class.getProtectionDomain().getCodeSource().getLocation().getPath();
        //CodeSource codeSource = MyMain.class.getProtectionDomain().getCodeSource();
        // returns null => NPE further down
        //System.out.println(codeSource.getLocation());
        //codeSource.getLocation().toURI();
        //codeSource.getLocation().toURI().getPath();
        //File progFile = new File(codeSource.getLocation().toURI().getPath());
        //String prog = progFile.getParentFile().getPath();
        //String srcdir = new File(prog).getParent();
        //System.out.println(srcdir);

        var lines = readInput();
        lines.forEach(System.out::println);
    }

    private static Stream<String> readInput() throws IOException {
        var reader = new BufferedReader(new InputStreamReader(System.in));
        if (!reader.ready())
            return Stream.empty();
        else
            return reader.lines();
    }

}
