import FeatherAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct UserRoleAddPage: Component {
    let form: UserRoleAddForm.State
    let nonceToken: String?

    func html(context: inout BuilderContext) -> Section {
        Section {
            context.build(NewAdminBreadcrumb(links: UserRoleRoutes.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add user role",
                        description: "Create a user role."
                    )
                )
            )
            context.build(
                UserRoleAddForm(
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
