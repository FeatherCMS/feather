import FeatherAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct UserRoleAddPage: Component {
    let form: UserRoleForm.State
    let nonceToken: String?

    func html(context: inout RenderContext) -> Section {
        Section {
            context.render(NewAdminBreadcrumb(links: UserRoleRoutes.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add user role",
                        description: "Create a user role."
                    )
                )
            )
            context.render(
                UserRoleForm(
                    state: form,
                    action: UserRoleRoutes.add.description,
                    submitLabel: "Add role",
                    viewHref: nil,
                    removeHref: nil,
                    nonceToken: nonceToken
                )
            )
        }
        .class("cms-section")
    }
}
