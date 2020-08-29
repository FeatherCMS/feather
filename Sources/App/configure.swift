//
//  configure.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import FeatherCore
/// drivers
import FluentSQLiteDriver
import LiquidLocalDriver
/// modules
import UserModule
import SystemModule

import AdminModule
import ApiModule
import FrontendModule

import SwiftyModule
import MarkdownModule
import RedirectModule
import SponsorModule
import StaticModule
import BlogModule

struct Feather {
    
}

func namespace() -> String {
    struct Foo {}
    return String(String(reflecting: Foo.self).split(separator: ".").first ?? "")
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
        return self.read(path: rootDirectory + moduleFile, on: eventLoop)
    }
}

protocol NIOLeafSource: LeafSource {

    var fileio: NonBlockingFileIO { get }
    /// reads an existing file and returns a byte buffer future
    func read(path: String, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer>
}

extension NIOLeafSource {
    func read(path: String, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        self.fileio.openFile(path: path, eventLoop: eventLoop)
        .flatMapErrorThrowing { _ in throw LeafError(.noTemplateExists(path)) }
        .flatMap { handle, region in
            self.fileio.read(fileRegion: region, allocator: .init(), eventLoop: eventLoop)
            .flatMapThrowing { buffer in
                try handle.close()
                return buffer
            }
        }
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
        
//        print("---")
//        print(name)
//        print(template)
//        print(path)
//        print(file)
//        print("---")

        if module == name {
            return self.read(path: file, on: eventLoop)
        }
        return eventLoop.future(error: LeafError(.noTemplateExists(path)))
    }
}


public func configure(_ app: Application) throws {

    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    
    //try app.databases.use(.postgres(url: Application.databaseUrl), as: .psql)
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    app.fileStorages.use(.local(publicUrl: Application.baseUrl,
                                publicPath: app.directory.publicDirectory,
                                workDirectory: "assets"), as: .local)

    app.routes.defaultMaxBodySize = "10mb"

    app.sessions.use(.fluent)
    app.migrations.add(SessionRecord.migration)
    app.middleware.use(SlashMiddleware())
    app.middleware.use(app.sessions.middleware)

    app.views.use(.leaf)
    app.leaf.tags[IsDebugTag.name] = IsDebugTag()
    app.leaf.tags[PathTag.name] = PathTag()
    app.leaf.tags[PathDropLastTag.name] = PathDropLastTag()
    app.leaf.tags[ParameterTag.name] = ParameterTag()
    app.leaf.tags[PermalinkTag.name] = PermalinkTag()
    app.leaf.tags[QueryTag.name] = QueryTag()
    app.leaf.tags[SetQueryTag.name] = SetQueryTag()
    app.leaf.tags[SortQueryTag.name] = SortQueryTag()
    app.leaf.tags[SortIndicatorTag.name] = SortIndicatorTag()
    app.leaf.tags[ResolveTag.name] = ResolveTag()
    app.leaf.tags[YearTag.name] = YearTag()
    app.leaf.tags[DateFormatterTag.name] = DateFormatterTag()
    app.leaf.tags[CountTag.name] = CountTag()
    app.leaf.tags[IsEmptyTag.name] = IsEmptyTag()
    app.leaf.tags[ContainsTag.name] = ContainsTag()

    let modules: [ViperModule] = [
        UserBuilder(),
        SystemBuilder(),
        
        AdminBuilder(),
        ApiBuilder(),
        FrontendBuilder(),

        SwiftyBuilder(),
        MarkdownBuilder(),
        RedirectBuilder(),
        SponsorBuilder(),
        StaticBuilder(),
        //BlogBuilder(),

    ].map { $0.build() }
    
//    let ns = namespace()
//    let modules = ["api", "admin", "frontend", "blog", "static", "sponsor"]
//
//    var dm = modules.map { m -> ViperModule in
//        let builderClass = NSClassFromString("\(ns).\(m.capitalized)Builder") as! ViperBuilder.Type
//        return builderClass.init().build()
//    }
    
    if !app.environment.isRelease && app.environment != .production {
        app.leaf.cache.isEnabled = false

        let nioLeaf = NIOLeafFiles(fileio: app.fileio,
                                   limits: [.requireExtensions],
                                   sandboxDirectory: app.directory.resourcesDirectory,
                                   viewDirectory: app.directory.viewsDirectory,
                                   defaultExtension: "html")
        
        let t = ViperViewFiles(rootDirectory: app.directory.workingDirectory,
                               modulesDirectory: "Sources/App/Modules",
                               resourcesDirectory: "Resources",
                               viewsFolderName: "Views",
                               fileExtension: "html",
                               fileio: app.fileio)

        let multipleSources = LeafSources()
        try multipleSources.register(using: nioLeaf)
        try multipleSources.register(source: "viper", using: t)

        
        for m in modules {
            guard let url = m.viewsUrl else { continue }

            //print(url.path.withTrailingSlash)

            let b = ViperBundledViewFiles(module: m.name,
                                          rootDirectory: url.path.withTrailingSlash,
                                          fileExtension: "html",
                                          fileio: app.fileio)

            try multipleSources.register(source: "\(m.name)-module", using: b)
        }
        app.leaf.sources = multipleSources
    }


    try app.viper.use(modules)

    try app.autoMigrate().wait()
}
