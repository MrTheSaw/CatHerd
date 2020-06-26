//
//  main.swift
//  swiftcat
//
//  Created by Hacksaw on 2020Apr27.
//  Copyright © 2020 Hacksaw. All rights reserved.
//

import Foundation
import ArgumentParser

enum SwiftCatErrors: Error {
    case File_Not_Found(filename: String)
    case Unable_To_Create(filename: String)
}

struct Swiftcat: ParsableCommand {
    
    @Option(name: .shortAndLong, help: "Name of the input file, defaults to stdin")
    var filein: String?
    
    @Option(name: [.customShort("o"), .long], help: "Name of output file, defaults to stdout")
    var fileout: String?
    
    @Option(name: .shortAndLong, help: "Line must match this regexp to get output")
    var regexMatch: String?
    
    @Option(name: [.customShort("R"), .customLong("regexNoMatch")], help: "Line must NOT match this regex to get output.")
    var regexNoMatch: String?
    
    func run() throws {
        //print ("In the run")
        let fm = FileManager()
        var streamIn: FileHandle? = nil
        if filein == nil {
            streamIn = FileHandle.standardInput
        } else {
            if fm.fileExists(atPath: filein!) {
                streamIn = FileHandle(forReadingAtPath: filein!)
            } else {
                FileHandle.standardError.write("File Not Found: \(filein!)\n".data(using: .utf8)!)
                throw ExitCode(1)
            }
        }
        
        var streamOut: FileHandle? = nil
        if fileout == nil {
            streamOut = FileHandle.standardOutput
        } else {
            fm.createFile(atPath: fileout!, contents: nil, attributes: nil)
            streamOut = FileHandle(forWritingAtPath: fileout!)
            if streamOut == nil {
                FileHandle.standardError.write("File couldn't be created: \(fileout!)\n".data(using: .utf8)!)
                throw ExitCode(1)
            }
        }
        
        //
        var buffer = Data()
        var line = Data()
        var notEOF = true
        var isGoodToGo = true
        var NoEnd: Bool = false
        
        while true {
            if notEOF { buffer.append(streamIn!.readData(ofLength: 256))}
            if buffer.count < 256 { notEOF = false }
            if buffer.count < 1 { break }
            line = buffer.prefix(while: {NoEnd = ($0 != 0x0a); return NoEnd})
            if !NoEnd {
                buffer.removeFirst(line.count)
                line.append(buffer.popFirst()!)
                
                //print(buffer.description)
                
                // Keep lines which match this...
                if regexMatch != nil {
                    isGoodToGo = String(decoding: line, as: UTF8.self).range(of: regexMatch!, options: .regularExpression) != nil
                }
                
                // ... unless they match this
                if regexNoMatch != nil {
                    isGoodToGo = isGoodToGo && (String(decoding: line, as: UTF8.self).range(of: regexNoMatch!, options: .regularExpression) == nil)
                }
                
                // whatever is left, we send
                if isGoodToGo {
                    streamOut!.write(line)
                    line.removeAll()
                }
                //reset for the next line
                isGoodToGo = true
            }
        }
    }
}

Swiftcat.main()
