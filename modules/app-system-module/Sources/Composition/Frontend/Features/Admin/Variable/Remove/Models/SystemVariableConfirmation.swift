import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import WebComponents
import WebBuilders

struct SystemVariableConfirmation: Leaf {

    struct State {
        let id: String
        let name: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        return AdminConfirmationDialog(
            state: .init(
                breadcrumb: state.breadcrumb,
                title: "Remove system variable",
                message:
                    "Are you sure you want to remove this system variable? This action cannot be undone.",
                details: [
                    .init(prefix: "Name: ", value: state.name)
                ],
                submitLabel: "Remove variable",
                actionURL: "/admin/system/variables/\(state.id)/remove/",
                cancelURL: "/admin/system/variables/"
            )
        ).html()
    }
}
