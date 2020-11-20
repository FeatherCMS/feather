//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 14..
//

import FeatherCore

public extension ViperModule {
    
    /// NOTE: use module.bundle later on...
    //static var modulesLocation = "Sources/App/Modules/"

    static func sample(asset name: String) -> String {
        let path = Application.Paths.base + "Sources/App/Modules/" + "\(Self.name)/Assets/sample/\(name)"
        do {
            return try String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
        }
        catch {
            fatalError("Invalid sample: \(error.localizedDescription)")
        }
    }
}

struct ViperBundledViewFiles: NonBlockingFileIOLeafSource {

    let module: String
    /// root directory
    let rootDirectory: String
    /// file extension
    let fileExtension: String
    /// fileio used to read files
    let fileio: NonBlockingFileIO

    /// file template function implementation
    func file(template: String, escape: Bool = false, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        let name = template.split(separator: "/").first!.lowercased()
        let path = template.split(separator: "/").dropFirst().map { String($0) }.joined(separator: "/")
        let file = rootDirectory + path  + "." + fileExtension
        print(file)
//        print("---")
//        print(name)
//        print(template)
//        print(path)
//        print(file)
//        print("---")

        if module == name {
            return read(path: file, on: eventLoop)
        }
        return eventLoop.future(error: LeafError(.noTemplateExists(path)))
    }
}


