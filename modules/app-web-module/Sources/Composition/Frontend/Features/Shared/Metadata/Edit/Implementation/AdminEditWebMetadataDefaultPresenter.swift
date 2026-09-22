import FeatherAdmin
import FeatherContracts
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditWebMetadataDefaultPresenter: AdminEditWebMetadataPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: WebMetadataForm.State,
        permissions: Set<String>,
        navigationTabs: [NewAdminTabBar.Link],
        configuration: AdminWebMetadataEditConfiguration?
    ) async throws -> HTMLResponse {
        let title = configuration?.title ?? "Edit web metadata"
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "\(title)",
            content: WebMetadataEdit(
                state: .init(
                    id: id,
                    form: state,
                    breadcrumb: breadcrumb(for: configuration),
                    action: request.uri.path,
                    navigationTabs: navigationTabs,
                    pageHeader: .init(
                        title: title,
                        description: configuration?.description
                            ?? "Edit the metadata used when this page is rendered and shared.",
                        previewHref: previewPath(for: state)
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
        configuration: AdminWebMetadataEditConfiguration?
    ) async throws -> HTMLResponse {
        let title = configuration?.title ?? "Edit web metadata"
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "\(title)",
            content: WebMetadataError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb(for: configuration)
                )
            )
        )
    }

    private func breadcrumb(
        for configuration: AdminWebMetadataEditConfiguration?
    ) -> [NewAdminBreadcrumb.Link] {
        if let breadcrumb = configuration?.breadcrumb {
            return breadcrumb
        }
        if let marker = request.uri.path.range(of: "/edit/metadata/") {
            let detailsPath =
                String(request.uri.path[..<marker.lowerBound]) + "/edit/"
            return [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Details", link: detailsPath),
            ]
        }
        return WebAdminRoutes.breadcrumb
    }

    private func previewPath(for state: WebMetadataForm.State) -> String? {
        guard let slug = state.slug.value else { return nil }
        let normalizedSlug = slug.whitespaceTrimmed
        return normalizedSlug.isEmpty ? nil : "/\(normalizedSlug)/"
    }
}
