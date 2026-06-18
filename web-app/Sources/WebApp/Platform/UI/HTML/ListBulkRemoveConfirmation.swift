import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct ListBulkRemoveConfirmation: Component {

    struct State {
        let breadcrumb: AdminBreadcrumb.State
        let title: String
        let message: String
        let action: String
        let cancelLink: String
        let selectedIds: [String]
    }

    let state: State

    func content() -> some BasicTag {
        let previewIds = state.selectedIds.prefix(10)
        let remainingIds = state.selectedIds.count - previewIds.count

        AdminConfirmationDialog(
            state: .init(
                breadcrumb: state.breadcrumb,
                title: state.title,
                message: state.message,
                details: [
                    .init(prefix: "Selected \(state.selectedIds.count) items.")
                ]
                    + (previewIds.isEmpty
                        ? []
                        : [
                            .init(
                                prefix: "IDs: ",
                                value: previewIds.joined(separator: ", "),
                                suffix: remainingIds > 0
                                    ? " and \(remainingIds) more" : nil
                            )
                        ]),
                submitLabel: "Remove selected",
                actionURL: state.action,
                cancelURL: state.cancelLink,
                hiddenFields: state.selectedIds.map {
                    .init(name: "selectedIds", value: $0)
                }
            )
        )
    }
}
