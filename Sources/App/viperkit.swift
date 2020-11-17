//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 14..
//

import Vapor
import Fluent
import ViperKit

public protocol ViperInstaller {
    func variables() -> [[String: Any]]
    func createModels(_: Request) -> EventLoopFuture<Void>?
}

public extension ViperInstaller {
    func variables() -> [[String: Any]] { [] }
    func createModels(_: Request) -> EventLoopFuture<Void>? { nil }
}

public extension ViperModule {
    
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


protocol NIOLeafSource: LeafSource {

    var fileio: NonBlockingFileIO { get }
    /// reads an existing file and returns a byte buffer future
    func read(path: String, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer>
}

extension NIOLeafSource {
    func read(path: String, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        fileio.openFile(path: path, eventLoop: eventLoop)
        .flatMapErrorThrowing { _ in throw LeafError(.noTemplateExists(path)) }
        .flatMap { handle, region in
            fileio.read(fileRegion: region, allocator: .init(), eventLoop: eventLoop)
            .flatMapThrowing { buffer in
                try handle.close()
                return buffer
            }
        }
    }
}



struct ViperViewFiles: NIOLeafSource {
    
    /// root directory of the project
    let rootDirectory: String
    /// modules directory
    let modulesDirectory: String
    /// resources directory name
    let resourcesDirectory: String
    /// views folder name
    let viewsFolderName: String
    /// file extension
    let fileExtension: String
    /// fileio used to read files
    let fileio: NonBlockingFileIO

    /// file template function implementation
    func file(template: String, escape: Bool = false, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        let ext = "." + fileExtension
        let components = template.split(separator: "/")
        let pathComponents = [String(components.first!), viewsFolderName] + components.dropFirst().map { String($0) }
        let moduleFile = modulesDirectory + "/" + pathComponents.joined(separator: "/") + ext
        return read(path: rootDirectory + moduleFile, on: eventLoop)
    }
}

struct ViperBundledViewFiles: NIOLeafSource {

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


