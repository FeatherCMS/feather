//
//  StaticModule.swift
//  FeatherCMS
//
//  Created by Tibor Bödecs on 2020. 06. 07..
//

import Vapor
import Fluent
import ViperKit
import ViewKit

final class StaticModule: ViperModule {

    static var name: String = "static"

    var router: ViperRouter? { StaticRouter() }

    func boot(_ app: Application) throws {
        app.databases.middleware.use(FrontendContentModelMiddleware<StaticPageModel>())
    }

    var migrations: [Migration] {
        [
            StaticPageMigration_v1_0_0(),
        ]
    }

    // MARK: - hook functions

    func invoke(name: String, req: Request, params: [String : Any] = [:]) -> EventLoopFuture<Any?>? {
        switch name {
        case "install":
            return self.installHook(req: req)
        case "frontend-page":
            return self.frontendPageHook(req: req)
        default:
            return nil
        }
    }

    private func frontendPageHook(req: Request) -> EventLoopFuture<Any?>? {
        StaticPageModel.joinedFrontendContentQuery(on: req.db, path: req.url.path)
        .filter(FrontendContentModel.self, \.$status != .archived)
        .first()
        .flatMap { page -> EventLoopFuture<Response?> in
            guard let page = page, let content = try? page.joined(FrontendContentModel.self) else {
                return req.eventLoop.future(nil)
            }

            if page.content.hasPrefix("["), page.content.hasSuffix("]") {
                let name = String(page.content.dropFirst().dropLast())
                return req.application.viper.invokeHook(name: name, req: req, type: Response.self, params: ["page-content": content])
            }

            let context = HTMLContext(content.headContext, content.filter(page.content, req: req))
            return req.view.render("Static/Frontend/Page", context)
                    .encodeResponse(for: req).map { $0 as Response? }
        }
        .map { $0 as Any }
    }

}
