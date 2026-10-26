import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModule

extension WebModule.Metadata.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let mediaAssetList: WebRoute

        func renderEditPage(
            id: String,
            state: WebModule.Metadata.Edit.Form.Component.State,
            permissions: Set<String>,
            navigationTabs: [AdminTabBar.Link],
            configuration: WebModule.Metadata.Edit.Configuration
        ) async throws -> HTMLResponse {
            let title = configuration.title
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "\(title)",
                content: WebModule.Metadata.Edit.Page(
                    state: .init(
                        id: id,
                        form: state,
                        mediaAssetList: mediaAssetList,
                        breadcrumb: configuration.breadcrumb,
                        action: request.uri.path,
                        navigationTabs: navigationTabs,
                        pageHeader: .primary(
                            title: title,
                            description: configuration.description,
                            preview: .init(
                                label: "Preview",
                                href: previewPath(for: state)
                            )
                        )
                    )
                )
            )
        }

        func renderErrorPage(
            id: String,
            info: String,
            message: String,
            permissions: Set<String>,
            configuration: WebModule.Metadata.Edit.Configuration
        ) async throws -> HTMLResponse {
            let title = configuration.title
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "\(title)",
                content: WebModule.Metadata.Edit.ErrorPage(
                    state: .init(
                        info: info,
                        message: message,
                        breadcrumb: configuration.breadcrumb
                    )
                )
            )
        }

        private func previewPath(
            for state: WebModule.Metadata.Edit.Form.Component.State
        ) -> String? {
            guard let slug = state.slug.value else { return nil }
            let normalizedSlug = slug.whitespaceTrimmed
            return normalizedSlug.isEmpty ? nil : "/\(normalizedSlug)/"
        }
    }
}
