import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import WebBuilders
import WebComponents

struct SystemPermissionEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: SystemPermissionForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Edit system permission")
            if state.isEdited { P("System permission edited successfully.") }
            context.render(
                SystemPermissionForm(
                    state: state.form,
                    action: "/admin/system/permissions/\(state.id)/edit/",
                    submitLabel: "Edit permission",
                    removeHref: "/admin/system/permissions/\(state.id)/remove/",
                    removeLabel: "Remove permission"
                )
            )
        }
        .class("cms-section")
    }
}
