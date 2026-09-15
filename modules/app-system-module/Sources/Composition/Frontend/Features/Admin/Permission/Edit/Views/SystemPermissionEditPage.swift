import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct SystemPermissionEditPage: Component {
    struct State {
        let id: String
        let isEdited: Bool
        let form: SystemPermissionEditForm.State
        let nonceToken: String?
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminBreadcrumb(links: SystemPermissionRoutes.breadcrumb)
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit system permission",
                        description: "Update this system permission."
                    )
                )
            )
            if state.isEdited { P("System permission edited successfully.") }
            context.build(
                SystemPermissionEditForm(
                    state: state.form,
                    action: SystemPermissionRoutes.edit(RouterPath(state.id))
                        .description,
                    viewHref:
                        SystemPermissionRoutes.details(RouterPath(state.id))
                        .description,
                    removeHref: NewAdminLocation.remove(
                        path: SystemPermissionRoutes.remove.description,
                        ids: [state.id],
                        returnTo:
                            SystemPermissionRoutes.edit(RouterPath(state.id))
                            .description
                    ),
                    nonceToken: state.nonceToken
                )
            )
        }
        .class("cms-section")
    }
}
