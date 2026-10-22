public import FeatherModuleKit
public import FeatherWebShared
public import HTML
public import Hummingbird
import WebBuilders
public import WebComponents

public struct DefaultRenderingEngine: RenderingEngine {
    public let adminEvents: any EventPublisher
    public let richContentEditorBlocks: [AdminRichContentEditorBlockDefinition]
    public let adminPageRenderContextProvider:
        any AdminPageRenderContextProvider

    public init(
        adminEvents: any EventPublisher,
        richContentEditorBlocks: [AdminRichContentEditorBlockDefinition] = [],
        adminPageRenderContextProvider: any AdminPageRenderContextProvider
    ) {
        self.adminEvents = adminEvents
        self.richContentEditorBlocks = richContentEditorBlocks
        self.adminPageRenderContextProvider = adminPageRenderContextProvider
    }

    public func renderAdminPage<T: Component>(
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
        let adminRemoveNonce = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        var builderContext = BuilderContext()
        let layout = AdminBaseLayout(
            content: content,
            menuGroups: renderContext.menuGroups,
            notification: notification,
            accountTopBarState: renderContext.accountTopBarState
        )
        return .init(
            builderContext.build(
                AdminHTML(
                    title: title,
                    body: .init(content: layout),
                    adminRemoveNonce: adminRemoveNonce,
                    richContentEditorBlocks: richContentEditorBlocks
                )
            )
        )
    }

    public func renderAdminDialog<T: Component>(
        request: Request,
        context: AuthenticatedRequestContext,
        title: String,
        content: T,
        size: AdminDialogSize = .small
    ) async throws -> HTMLResponse {
        var builderContext = BuilderContext()
        return .init(
            builderContext.build(
                AdminHTML(
                    title: title,
                    body: .init(
                        content: AdminDialog(
                            title: title,
                            content: content,
                            size: size
                        ),
                        showsFooter: false
                    ),
                    richContentEditorBlocks: richContentEditorBlocks
                )
            )
        )
    }

    public func renderAdminStandalonePage<T: Component>(
        title: String,
        content: T
    ) -> HTMLResponse where T.HTML: FlowContent {
        var builderContext = BuilderContext()
        return .init(
            builderContext.build(
                AdminHTML(
                    title: title,
                    body: .init(content: content, showsFooter: false),
                    richContentEditorBlocks: richContentEditorBlocks
                )
            )
        )
    }
}
