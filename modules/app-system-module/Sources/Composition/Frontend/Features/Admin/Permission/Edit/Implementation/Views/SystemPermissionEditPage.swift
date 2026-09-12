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

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(
                NewAdminBreadcrumb(state: SystemPermissionRoutes.breadcrumb)
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit system permission",
                        description: "Update this system permission."
                    )
                )
            )
            if state.isEdited { P("System permission edited successfully.") }
            context.render(
                SystemPermissionEditForm(
                    state: state.form,
                    action: SystemPermissionRoutes.edit(RouterPath(state.id))
                        .description,
                    viewHref:
                        SystemPermissionRoutes.details(RouterPath(state.id))
                        .description,
                    removeHref: SystemPermissionRoutes.removeFromEdit(state.id),
                    nonceToken: state.nonceToken
                )
            )
        }
        .class("cms-section")
    }
}
