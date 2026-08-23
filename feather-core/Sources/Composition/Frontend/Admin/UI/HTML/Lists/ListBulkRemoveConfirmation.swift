import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

public struct ListBulkRemoveConfirmation: Component {

    public struct State: Sendable {
        public let breadcrumb: AdminBreadcrumb.State
        public let title: String
        public let message: String
        public let action: String
        public let cancelLink: String
        public let selectedIds: [String]

        public init(
            breadcrumb: AdminBreadcrumb.State,
            title: String,
            message: String,
            action: String,
            cancelLink: String,
            selectedIds: [String]
        ) {
            self.breadcrumb = breadcrumb
            self.title = title
            self.message = message
            self.action = action
            self.cancelLink = cancelLink
            self.selectedIds = selectedIds
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func content() -> some BasicTag {
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
