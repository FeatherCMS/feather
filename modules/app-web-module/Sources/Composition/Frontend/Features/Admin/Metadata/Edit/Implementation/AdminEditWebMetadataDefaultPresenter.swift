import FeatherAdmin
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditWebMetadataDefaultPresenter: AdminEditWebMetadataPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: WebMetadataForm.State,
        isEdited: Bool,
        permissions: Set<String>,
        navigationTabs: [AdminPillTabs.Link],
        configuration: AdminWebMetadataEditConfiguration?
    ) -> HTMLResponse {
        let title = configuration?.title ?? "Edit web metadata"
        return renderingEngine.renderAdminPage(
            request: request,
            title: "\(title)",
            description: "Edit a management web metadata",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebMetadataEdit(
                state: .init(
                    id: id,
                    isEdited: isEdited,
                    form: state,
                    breadcrumb: configuration?.breadcrumb ?? breadcrumb(id: id),
                    action: request.uri.path,
                    navigationTabs: navigationTabs,
                    title: title
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
    ) -> HTMLResponse {
        let title = configuration?.title ?? "Edit web metadata"
        return renderingEngine.renderAdminPage(
            request: request,
            title: "\(title)",
            description: "Edit a management web metadata",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
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
    ) -> AdminBreadcrumb.State {
        let path = request.uri.path
        if let marker = path.range(of: "/edit/metadata/") {
            let detailsPath = String(path[..<marker.lowerBound]) + "/edit/"
            return .init(
                links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Details", link: detailsPath),
                    .init(label: "Metadata", link: path),
                ]
            )
        }
        return .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Web", link: "/admin/web/"),
                .init(label: "Metadata", link: "/admin/web/metadata/"),
                .init(
                    label: "Edit",
                    link: "/admin/web/metadata/\(id)/edit/"
                ),
            ]
        )
    }
}
