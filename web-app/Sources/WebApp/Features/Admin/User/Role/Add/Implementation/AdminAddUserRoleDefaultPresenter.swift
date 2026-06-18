import Foundation
import Hummingbird

struct AdminAddUserRoleDefaultPresenter: AdminAddUserRolePresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        form: UserRoleForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Add user role - Feather CMS",
            description: "Add a user role in management",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserRoleAdd(
                state: .init(
                    form: form,
                    breadcrumb: breadcrumb()
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

    func breadcrumb() -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "User", link: "/admin/user/"),
            .init(label: "Roles", link: "/admin/user/roles/"),
            .init(label: "Add", link: "/admin/user/roles/add/"),
        ])
    }

    func format(
        error: OpenAPIRepositoryError
    ) -> String {
        error.errorDescription
    }
}
