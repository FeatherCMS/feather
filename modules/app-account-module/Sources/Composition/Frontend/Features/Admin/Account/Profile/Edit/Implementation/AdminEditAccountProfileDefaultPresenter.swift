import FeatherAdmin
import HTML
import Hummingbird

struct AdminEditAccountProfileDefaultPresenter:
    AdminEditAccountProfilePresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func render(
        userID: String,
        model: AdminEditAccountProfileModel,
        canEdit: Bool,
        isEdited: Bool,
        permissions: Set<String>
    ) -> HTMLResponse {
        let path = "/admin/account/users/\(userID)/profile/"
        return renderEngine.renderAdminPage(
            request: request,
            title: "Profile",
            description: "Edit user profile",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AccountProfileEdit(
                userID: userID,
                state: .init(
                    firstName: model.firstName,
                    lastName: model.lastName,
                    imageURL: model.imageURL,
                    canEdit: canEdit,
                    action: path
                ),
                isEdited: isEdited
            )
        )
    }

    func renderDeniedPage(
        userID: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "No permission",
            description: "No permission",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: PermissionDeniedView(
                state: .init(
                    info: "No permission",
                    message: "Your account cannot view this profile.",
                    breadcrumb: .init(
                        links: [
                            .init(label: "Admin", link: "/admin/"),
                            .init(label: "User", link: "/admin/user/"),
                            .init(
                                label: "Profile",
                                link: "/admin/account/users/\(userID)/profile/"
                            ),
                        ]
                    )
                )
            )
        )
    }
}
