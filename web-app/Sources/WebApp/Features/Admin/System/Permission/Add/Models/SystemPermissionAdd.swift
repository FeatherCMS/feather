import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct SystemPermissionAdd: Component {

    struct State {
        let form: SystemPermissionForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Add system permission")
            SystemPermissionForm(
                state: state.form,
                action: "/admin/system/permissions/add/",
                submitLabel: "Add permission"
            )
        }
        .class("cms-section")
    }
}
