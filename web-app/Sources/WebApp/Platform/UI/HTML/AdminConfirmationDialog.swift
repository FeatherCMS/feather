import HTML
import SGML
import WebStandards

struct AdminConfirmationDialog: Component {

    struct HiddenField {
        let name: String
        let value: String
    }

    struct Detail {
        let prefix: String
        let value: String?
        let suffix: String?

        init(
            prefix: String,
            value: String? = nil,
            suffix: String? = nil
        ) {
            self.prefix = prefix
            self.value = value
            self.suffix = suffix
        }
    }

    struct State {
        let breadcrumb: AdminBreadcrumb.State
        let title: String
        let message: String
        let details: [Detail]
        let submitLabel: String
        let actionURL: String
        let cancelURL: String
        let cancelLabel: String
        let hiddenFields: [HiddenField]

        init(
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

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

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
                        .setAttribute(
                            name: "onclick",
                            value:
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
