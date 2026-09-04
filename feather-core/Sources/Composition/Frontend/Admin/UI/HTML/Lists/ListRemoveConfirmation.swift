import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebComponents
import WebBuilders

public struct ListRemoveConfirmation: Leaf {

    public struct State: Sendable {
        public let breadcrumb: AdminBreadcrumb.State
        public let title: String
        public let message: String
        public let action: String
        public let cancelLink: String
        public let selectedIds: [String]
        public let hiddenFields: [AdminConfirmationDialog.HiddenField]

        public init(
            breadcrumb: AdminBreadcrumb.State,
            title: String,
            message: String,
            action: String,
            cancelLink: String,
            selectedIds: [String],
            hiddenFields: [AdminConfirmationDialog.HiddenField] = []
        ) {
            self.breadcrumb = breadcrumb
            self.title = title
            self.message = message
            self.action = action
            self.cancelLink = cancelLink
            self.selectedIds = selectedIds
            self.hiddenFields = hiddenFields
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func renderHTML() -> some BasicTag {
        let previewIds = state.selectedIds.prefix(10)
        let remainingIds = state.selectedIds.count - previewIds.count

        return AdminConfirmationDialog(
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
                } + state.hiddenFields
            )
        ).renderHTML()
    }
}
