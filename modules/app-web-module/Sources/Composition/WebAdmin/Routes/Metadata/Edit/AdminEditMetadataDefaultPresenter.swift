import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import Builders
import Components

struct AdminEditMetadataDefaultPresenter: AdminEditMetadataPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: MetadataForm.State,
        permissions: Set<String>,
        navigationTabs: [AdminTabBar.Link],
        configuration: AdminMetadataEditConfiguration?
    ) async throws -> HTMLResponse {
        let title = configuration?.title ?? "Edit web metadata"
        return try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "\(title)",
            content: MetadataEdit(
                state: .init(
                    id: id,
                    form: state,
                    breadcrumb: breadcrumb(for: configuration),
                    action: request.uri.path,
                    navigationTabs: navigationTabs,
                    pageHeader: .primary(
                        title: title,
                        description: configuration?.description
                            ?? "Edit the metadata used when this page is rendered and shared.",
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
        configuration: AdminMetadataEditConfiguration?
    ) async throws -> HTMLResponse {
        let title = configuration?.title ?? "Edit web metadata"
        return try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "\(title)",
            content: MetadataError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb(for: configuration)
                )
            )
        )
    }

    private func breadcrumb(
        for configuration: AdminMetadataEditConfiguration?
    ) -> [AdminBreadcrumb.Link] {
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
        return AdminRoutes.breadcrumb
    }

    private func previewPath(for state: MetadataForm.State) -> String? {
        guard let slug = state.slug.value else { return nil }
        let normalizedSlug = slug.whitespaceTrimmed
        return normalizedSlug.isEmpty ? nil : "/\(normalizedSlug)/"
    }
}
