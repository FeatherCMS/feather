import HTML
import SGML
import WebStandards

struct AdminContactSubmissionsDirectoryView: Component {
    let items: [AdminContactSubmissionDirectoryItem]
    let breadcrumb: AdminBreadcrumb.State
    let error: String?

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb)
            H1("Submissions")
            P("All contact form submissions.")
            if let error { P(error).class("error") }
            if items.isEmpty {
                P("No submissions yet.")
            } else {
                ListTableShell(table: Table {
                    Thead { Tr { Th("Form"); Th("Submitted"); Th("Status"); Th("Actions") } }
                    Tbody {
                        for item in items {
                            Tr {
                                Td(item.formName).data("label", "Form")
                                Td(item.submittedAt).data("label", "Submitted")
                                Td(item.status).data("label", "Status")
                                ListTableRowActions(state: .init(
                                    label: "Actions",
                                    actions: [.init(title: "Details", href: "/admin/contact/forms/\(item.formId)/submissions/\(item.id)/", className: nil, permission: "contact:form-submissions:read")],
                                    permissions: ["contact:form-submissions:read"]
                                ))
                            }
                        }
                    }
                }.class("cms-table", "action-table"))
            }
        }.class("cms-section")
    }
}
