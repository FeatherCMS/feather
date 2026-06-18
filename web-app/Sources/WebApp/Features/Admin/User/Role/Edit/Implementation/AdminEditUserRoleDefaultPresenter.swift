import Foundation
import Hummingbird

struct AdminEditUserRoleDefaultPresenter: AdminEditUserRolePresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: UserRoleForm.State,
        isEdited: Bool,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit user role - Feather CMS",
            description: "Edit a management user role",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserRoleEdit(
                state: .init(
                    id: id,
                    isEdited: isEdited,
                    form: state,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit user role - Feather CMS",
            description: "Edit a management user role",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserRoleError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }

    func formState(
        name: String = "",
        notes: String = ""
    ) -> UserRoleForm.State {
        .init(
            name: .init(key: "name", label: "Name", value: name, error: nil),
            notes: .init(
                key: "notes",
                label: "Notes",
                value: notes,
                error: nil
            ),
            error: nil,
            success: nil
        )
    }

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "User", link: "/admin/user/"),
            .init(label: "Roles", link: "/admin/user/roles/"),
            .init(label: "Edit", link: "/admin/user/roles/\(id)/edit/"),
        ])
    }

    func format(
        error: OpenAPIRepositoryError
    ) -> String {
        error.errorDescription
    }
}
