import HTML
import SGML
import WebStandards

struct ContactFormSubmissionDetailView: Component {
    struct State {
        let formId: String
        let item: AdminContactFormSubmissionItem
        let error: String?
        let isEdited: Bool
        let breadcrumb: AdminBreadcrumb.State
    }
    let state: State
    func content() -> some BasicTag {
        Section {
            AdminContactFormTabs(formId: state.formId, active: .submissions)
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Contact form submission")
            if let error = state.error { P(error).class("error") }
            if state.isEdited { P("Submission status updated successfully.") }
            P("Submitted: \(state.item.createdAt)")
            H2("Values")
            if state.item.values.isEmpty {
                P("No values recorded.")
            }
            else {
                Table {
                    Tbody {
                        for (key, value) in state.item.values.sorted(by: {
                            $0.key < $1.key
                        }) {
                            Tr {
                                Th(key)
                                Td(value)
                            }
                        }
                    }
                }
                .class("cms-table")
            }
            Form {
                Label {
                    AdminFieldLabel(label: "Status", required: true)
                    Select {
                        for status in [
                            "received", "processed", "spam", "failed",
                        ] {
                            Option(status.capitalized).value(status)
                                .if(state.item.status == status) {
                                    $0.selected()
                                }
                        }
                    }
                    .name("status").class("text-input")
                }
                Div { Button("Save status").type(.submit) }.class("button-row")
            }
            .method(.post)
            .action(
                "/admin/contact/forms/\(state.formId)/submissions/\(state.item.id)/"
            )
            .class("cms-form")
        }
        .class("cms-section")
    }
}
