import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct SystemVariableConfirmation: Component {

    struct State {
        let id: String
        let name: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        AdminConfirmationDialog(
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
        )
    }
}
