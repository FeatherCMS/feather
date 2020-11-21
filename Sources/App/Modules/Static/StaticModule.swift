//
//  StaticModule.swift
//  Feather
//
//  Created by Tibor Bödecs on 2020. 06. 07..
//

import FeatherCore

final class StaticModule: ViperModule {

    static var name: String = "static"

    var router: ViperRouter? { StaticRouter() }

    var migrations: [Migration] {
        [
            StaticPageMigration_v1_0_0(),
        ]
    }
    
    static var bundleUrl: URL? {
        URL(fileURLWithPath: Application.Paths.base)
            .appendingPathComponent("Sources")
            .appendingPathComponent("App")
            .appendingPathComponent("Modules")
            .appendingPathComponent("Static")
            .appendingPathComponent("Bundle")
    }
    
    func boot(_ app: Application) throws {
        app.databases.middleware.use(MetadataMiddleware<StaticPageModel>())

        app.hooks.register("admin", use: (router as! StaticRouter).adminRoutesHook)
        app.hooks.register("installer", use: installerHook)
        app.hooks.register("frontend-page", use: frontendPageHook)
        app.hooks.register("leaf-admin-menu", use: leafAdminMenuHook)
    }

    // MARK: - hooks

    func leafAdminMenuHook(args: HookArguments) -> LeafDataRepresentable {
        [
            "name": "Static",
            "icon": "file-text",
            "items": LeafData.array([
                [
                    "url": "/admin/static/pages/",
                    "label": "Pages",
                ],
            ])
        ]
    }
    
    func installerHook(args: HookArguments) -> ViperInstaller {
        StaticInstaller()
    }

    func frontendPageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request

        return StaticPageModel.findMetadata(on: req.db, path: req.url.path)
        .filter(Metadata.self, \.$status != .archived)
        .first()
        .flatMap { page -> EventLoopFuture<Response?> in
            guard let page = page, let metadata = try? page.joined(Metadata.self) else {
                return req.eventLoop.future(nil)
            }

            /// if the page is implemented as a Swift page handler, the page-content hook will take care of the rest.
            if page.content.hasPrefix("["), page.content.hasSuffix("]") {
                let name = String(page.content.dropFirst().dropLast())
                let futures: [EventLoopFuture<Response?>] = req.invokeAll(name, args: ["page-metadata": metadata])
                return req.eventLoop.findFirstValue(futures)
            }

            let filteredContent = metadata.filter(page.content, req: req)

            return req.leaf.render(template: "Static/Frontend/Page", context: [
                "page": [
                    "id": LeafData.string(page.id?.uuidString),
                    "title": LeafData.string(page.title),
                    "content": LeafData.string(filteredContent),
                ],
                "metadata": metadata.leafData,
            ])
            .encodeOptionalResponse(for: req)
        }
    }

}
