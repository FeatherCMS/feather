import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import WebComponents
import WebBuilders

struct SystemPermissionAdd: Leaf {

    struct State {
        let form: SystemPermissionForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1("Add system permission")
            SystemPermissionForm(
                state: state.form,
                action: "/admin/system/permissions/add/",
                submitLabel: "Add permission"
            ).renderHTML()
        }
        .class("cms-section")
    }
}
