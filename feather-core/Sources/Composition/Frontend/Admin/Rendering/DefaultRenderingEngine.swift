import CSS
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

public struct RenderingEngineAssetConfiguration: Sendable {
    public let publicStylesheetPaths: [String]
    public let adminStylesheetPaths: [String]
    public let rootStylesheetPath: String?

    public init(
        publicStylesheetPaths: [String] = [
            "/admin/base.css",
            "/admin/style.css",
            "/admin/toast.css",
        ],
        adminStylesheetPaths: [String] = [
            "/admin/base.css",
            "/admin/style.css",
            "/admin/toast.css",
        ],
        rootStylesheetPath: String? = nil
    ) {
        self.publicStylesheetPaths = publicStylesheetPaths
        self.adminStylesheetPaths = adminStylesheetPaths
        self.rootStylesheetPath = rootStylesheetPath
    }
}

public struct DefaultRenderingEngine: RenderingEngine {
    public let publicOrigins: AppPublicOriginConfiguration
    public let adminEvents: any EventPublisher
    public let assets: RenderingEngineAssetConfiguration

    public init(
        publicOrigins: AppPublicOriginConfiguration,
        adminEvents: any EventPublisher,
        assets: RenderingEngineAssetConfiguration = .init()
    ) {
        self.publicOrigins = publicOrigins
        self.adminEvents = adminEvents
        self.assets = assets
    }

    public func renderPublicPage<T: FlowContent>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        content: T
    ) -> HTMLResponse {
        var context = BuilderContext()
        let body = Body {
            content
        }

        let metadata = context.build(
            NewAdminMetadata(
                canonicalUrl: normalizedURL(
                    base: publicOrigins.siteBaseURL,
                    path: request.uri.path
                ),
                title: title,
                description: description,
                imageUrl: normalizedURL(
                    base: publicOrigins.staticBaseURL,
                    path: imagePath
                ),
                noIndex: false
            )
        )
        var headElements =
            metadata.children
            + assets.publicStylesheetPaths.map {
                Link(rel: .stylesheet).href(stylesheetURL(path: $0))
            }
        if let path = assets.rootStylesheetPath {
            headElements.append(Link(rel: .stylesheet).href(path))
        }
        let head = Head(
            elements: headElements.compactMap { $0 as? any MetadataContent }
        )

        let html = Html {
            head
            body
        }
        .lang("en-US")

        return .init(html)
    }

    public func renderNewAdminPage<T: Component>(
        request: Request,
        context: DefaultRequestContext,
        title: String,
        content: T
    ) async throws -> HTMLResponse {
        let menuGroups = try await context.adminMenuGroups(
            request: request,
            events: adminEvents
        )
        let notification = AdminNotificationFlash.notification(from: request)
        var builderContext = BuilderContext()
        let layout = NewAdminBaseLayout(
            content: content,
            menuGroups: menuGroups,
            notification: notification,
            accountTopBarState: context.accountTopBarState
        )
        return .init(
            builderContext.build(
                NewAdminHTML(title: title, body: .init(content: layout))
            )
        )
    }

    private func normalizedURL(
        base: String,
        path: String
    ) -> String {
        var url = base
        if !url.hasSuffix("/") { url += "/" }
        let normalizedPath =
            path.hasPrefix("/") ? String(path.dropFirst()) : path
        if normalizedPath.isEmpty { return url }
        url += normalizedPath
        if normalizedPath.contains(".") { return url }
        if !url.hasSuffix("/") { url += "/" }
        return url
    }

    private func stylesheetURL(path: String) -> String {
        normalizedURL(base: publicOrigins.staticBaseURL, path: path)
    }

}
