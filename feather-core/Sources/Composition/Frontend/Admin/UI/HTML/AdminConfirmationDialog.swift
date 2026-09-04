import HTML
import SGML
import WebComponents
import WebBuilders

public struct AdminConfirmationDialog: Leaf {

    public struct HiddenField: Sendable {
        public let name: String
        public let value: String

        public init(name: String, value: String) {
            self.name = name
            self.value = value
        }
    }

    public struct Detail: Sendable {
        public let prefix: String
        public let value: String?
        public let suffix: String?

        public init(
            prefix: String,
            value: String? = nil,
            suffix: String? = nil
        ) {
            self.prefix = prefix
            self.value = value
            self.suffix = suffix
        }
    }

    public struct State: Sendable {
        public let breadcrumb: AdminBreadcrumb.State
        public let title: String
        public let message: String
        public let details: [Detail]
        public let submitLabel: String
        public let actionURL: String
        public let cancelURL: String
        public let cancelLabel: String
        public let hiddenFields: [HiddenField]

        public init(
            breadcrumb: AdminBreadcrumb.State,
            title: String,
            message: String,
            details: [Detail] = [],
            submitLabel: String,
            actionURL: String,
            cancelURL: String,
            cancelLabel: String = "Cancel",
            hiddenFields: [HiddenField] = []
        ) {
            self.breadcrumb = breadcrumb
            self.title = title
            self.message = message
            self.details = details
            self.submitLabel = submitLabel
            self.actionURL = actionURL
            self.cancelURL = cancelURL
            self.cancelLabel = cancelLabel
            self.hiddenFields = hiddenFields
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()

            Div {
                H1(state.title)
                    .id("confirmTitle")
                P(state.message)
                    .id("confirmSubtitle")

                if !state.details.isEmpty {
                    Div {
                        for detail in state.details {
                            P {
                                detail.prefix
                                if let value = detail.value {
                                    Strong(value)
                                }
                                if let suffix = detail.suffix {
                                    suffix
                                }
                            }
                        }
                    }
                    .class("confirm-meta")
                }

                Div {
                    Form {
                        for field in state.hiddenFields {
                            Input()
                                .type(.hidden)
                                .name(field.name)
                                .value(field.value)
                        }

                        Input()
                            .type(.submit)
                            .value(state.submitLabel)
                            .class("danger")
                    }
                    .method(.post)
                    .action(state.actionURL)

                    A(state.cancelLabel)
                        .href(state.cancelURL)
                        .class("ghost")
                        .onClick(
                            "if (document.referrer) { window.location.href = document.referrer; return false; }"
                        )
                }
                .class("button-row")
            }
            .class("confirm-card")
            .role("alertdialog")
            .ariaLabelledBy("confirmTitle")
            .ariaDescribedBy("confirmSubtitle")
        }
        .class("cms-section")
    }
}
