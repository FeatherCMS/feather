import CSS
public import FeatherContracts
public import HTML
public import Hummingbird
import SGML
import WebBuilders
public import WebComponents

public struct DefaultRenderingEngine: RenderingEngine {
    public let publicOrigins: AppPublicOriginConfiguration
    public let adminEvents: any EventPublisher
    public let adminPageRenderContextProvider:
        any AdminPageRenderContextProvider

    public init(
        publicOrigins: AppPublicOriginConfiguration,
        adminEvents: any EventPublisher,
        adminPageRenderContextProvider: any AdminPageRenderContextProvider
    ) {
        self.publicOrigins = publicOrigins
        self.adminEvents = adminEvents
        self.adminPageRenderContextProvider = adminPageRenderContextProvider
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
        let head = Head(
            elements: metadata.children.compactMap {
                $0 as? any MetadataContent
            }
        )
        let html = Html {
            head
            body
        }
        .lang("en-US")
        return .init(html)
    }

    public func renderPublicPage<T: Component>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        content: T
    ) -> HTMLResponse where T.HTML: FlowContent {
        var context = BuilderContext()
        let contentHTML = context.build(content)
        let body = Body {
            contentHTML
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
        let cssRenderer = CSSRenderer(minify: false, indent: 4)
        let css = cssRenderer.render(context.stylesheet())
        let scripts = context.scripts()
        let headElements = metadata.children
        var renderedHeadElements = headElements.compactMap {
            $0 as? any MetadataContent
        }
        renderedHeadElements.append(
            Link(rel: .stylesheet).href("/admin/style.css")
        )
        if !css.isEmpty {
            renderedHeadElements.append(Style(css))
        }
        for script in scripts where !script.isEmpty {
            renderedHeadElements.append(Script(script))
        }
        let head = Head(elements: renderedHeadElements)

        let html = Html {
            head
            body
        }
        .lang("en-US")

        return .init(html)
    }

    public func renderNewAdminPage<T: Component>(
        request: Request,
        context: AuthenticatedRequestContext,
        title: String,
        content: T
    ) async throws -> HTMLResponse {
        let renderContext = try await adminPageRenderContextProvider.make(
            request: request,
            context: context
        )
        let notification = AdminNotificationFlash.notification(from: request)
        var builderContext = BuilderContext()
        let layout = NewAdminBaseLayout(
            content: content,
            menuGroups: renderContext.menuGroups,
            notification: notification,
            accountTopBarState: renderContext.accountTopBarState
        )
        return .init(
            builderContext.build(
                NewAdminHTML(title: title, body: .init(content: layout))
            )
        )
    }

    public func renderNewAdminDialog<T: Component>(
        request: Request,
        context: AuthenticatedRequestContext,
        title: String,
        content: T,
        size: NewAdminDialogSize = .small
    ) async throws -> HTMLResponse {
        var builderContext = BuilderContext()
        return .init(
            builderContext.build(
                NewAdminHTML(
                    title: title,
                    body: .init(
                        content: NewAdminDialog(
                            title: title,
                            content: content,
                            size: size
                        ),
                        showsFooter: false
                    )
                )
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

}
