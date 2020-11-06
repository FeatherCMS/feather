//
//  StaticModule.swift
//  Feather
//
//  Created by Tibor Bödecs on 2020. 06. 07..
//

import Vapor
import Fluent
import ViperKit
import ViewKit
import FeatherCore

final class StaticModule: ViperModule {

    static var name: String = "static"

    var router: ViperRouter? { StaticRouter() }

    func boot(_ app: Application) throws {
        app.databases.middleware.use(MetadataMiddleware<StaticPageModel>())
    }

    var migrations: [Migration] {
        [
            StaticPageMigration_v1_0_0(),
        ]
    }

    var viewsUrl: URL? {
        nil
//        Bundle.module.bundleURL
//            .appendingPathComponent("Contents")
//            .appendingPathComponent("Resources")
//            .appendingPathComponent("Views")
    }

    // MARK: - hook functions

    func invoke(name: String, req: Request, params: [String : Any] = [:]) -> EventLoopFuture<Any?>? {
        switch name {
        case "install":
            return installHook(req: req)
        case "frontend-page":
            return frontendPageHook(req: req)
        default:
            return nil
        }
    }

    private func frontendPageHook(req: Request) -> EventLoopFuture<Any?>? {
        StaticPageModel.findMetadata(on: req.db, path: req.url.path)
        .filter(Metadata.self, \.$status != .archived)
        .first()
        .flatMap { page -> EventLoopFuture<Response?> in
            guard let page = page, let content = try? page.joined(Metadata.self) else {
                return req.eventLoop.future(nil)
            }

            if page.content.hasPrefix("["), page.content.hasSuffix("]") {
                let name = String(page.content.dropFirst().dropLast())
                return req.application.viper.invokeHook(name: name, req: req, type: Response.self, params: ["page-content": content])
            }

            #warning("HEAD has incorrect values!")
            let body = content.filter(page.content, req: req)
            return req.leaf.render(template: "Static/Frontend/Page", context: [
                "head": content.leafData,
                "body": .string(body)
            ])
            .encodeResponse(for: req).map { $0 as Response? }
        }
        .map { $0 as Any }
    }

}
