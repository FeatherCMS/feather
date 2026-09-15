import FeatherAdmin
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
                    breadcrumb: configuration?.breadcrumb ?? breadcrumb(id: id),
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
                    breadcrumb: configuration?.breadcrumb ?? breadcrumb(id: id)
                )
            )
        )
    }

    func breadcrumb(
        id: String
    ) -> [NewAdminBreadcrumb.Link] {
        let path = request.uri.path
        if let marker = path.range(of: "/edit/metadata/") {
            let detailsPath = String(path[..<marker.lowerBound]) + "/edit/"
            return [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Details", link: detailsPath),
            ]
        }
        return [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Web", link: "/admin/web/"),
            .init(label: "Metadata", link: "/admin/web/metadata/"),
        ]
    }

    private func previewPath(for state: WebMetadataForm.State) -> String? {
        guard let slug = state.slug.value else { return nil }
        let normalizedSlug = slug.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        return normalizedSlug.isEmpty ? nil : "/\(normalizedSlug)/"
    }
}
