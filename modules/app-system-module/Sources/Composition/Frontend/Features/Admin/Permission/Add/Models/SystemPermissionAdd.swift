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

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()

            H1("Add system permission")
            SystemPermissionForm(
                state: state.form,
                action: "/admin/system/permissions/add/",
                submitLabel: "Add permission"
            ).html()
        }
        .class("cms-section")
    }
}
