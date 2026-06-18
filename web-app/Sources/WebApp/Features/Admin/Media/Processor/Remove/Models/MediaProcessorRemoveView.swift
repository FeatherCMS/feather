import HTML
import SGML
import WebStandards

struct MediaProcessorRemoveView: Component {
    let id: String
    let cancelURL: String
    let formURL: String
    let breadcrumb: AdminBreadcrumb.State

    func content() -> some BasicTag {
        AdminConfirmationDialog(
            state: .init(
                breadcrumb: breadcrumb,
                title: "Remove processor",
                message:
                    "Are you sure you want to remove this processor? This action cannot be undone.",
                details: [
                    .init(prefix: "ID: ", value: id)
                ],
                submitLabel: "Remove processor",
                actionURL: formURL,
                cancelURL: cancelURL
            )
        )
    }
}
