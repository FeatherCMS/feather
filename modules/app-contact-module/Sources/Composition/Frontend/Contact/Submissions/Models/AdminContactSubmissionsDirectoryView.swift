import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminContactSubmissionsDirectoryView: Leaf {
    let items: [AdminContactSubmissionDirectoryItem]
    let search: String
    let canRemove: Bool
    let breadcrumb: AdminBreadcrumb.State
    let error: String?

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb).html()
            H1("Submissions")
            P("All contact form submissions.")
            if let error { P(error).class("error") }
            ListTableSearchForm(
                state: .init(
                    action: "/admin/contact/submissions/",
                    placeholder: "Quick search contact submissions",
                    search: search
                )
            ).html()
            if items.isEmpty {
                P(
                    search.isEmpty
                        ? "No submissions yet."
                        : "No submissions match your search."
                )
            }
            else {
                ListTableRemoveForm(
                    state: .init(
                        action: "/admin/contact/submissions/remove/",
                        page: 1,
                        search: search,
                        canRemove: canRemove,
                        buttonTitle: "Remove selected"
                    ),
                    table: ListTableShell(
                        table: Table {
                            Thead {
                                Tr {
                                    if canRemove {
                                        ListTableSelectAllCheckbox().html()
                                    }
                                    Th("Form")
                                    Th("Submitted")
                                    if hasEmailColumn { Th("Email") }
                                    Th("Status")
                                    Th("Actions")
                                }
                            }
                            Tbody {
                                for item in items {
                                    Tr {
                                        if canRemove {
                                            ListTableRowSelectCheckbox(
                                                state: .init(
                                                    id:
                                                        "\(item.formId):\(item.id)"
                                                )
                                            ).html()
                                        }
                                        Td(item.formName).data("label", "Form")
                                        Td(item.createdAt)
                                            .data("label", "Submitted")
                                        if hasEmailColumn {
                                            Td(item.email ?? "—")
                                                .data("label", "Email")
                                        }
                                        Td(item.status).data("label", "Status")
                                        ListTableRowActions(
                                            state: .init(
                                                label: "Actions",
                                                actions: [
                                                    .init(
                                                        title: "Details",
                                                        href:
                                                            "/admin/contact/forms/\(item.formId)/submissions/\(item.id)/",
                                                        className: nil,
                                                        permission:
                                                            "contact:form-submissions:read"
                                                    ),
                                                    .init(
                                                        title: "Remove",
                                                        href:
                                                            "/admin/contact/forms/\(item.formId)/submissions/\(item.id)/remove/",
                                                        className: "delete",
                                                        permission:
                                                            "contact:form-submissions:delete"
                                                    ),
                                                ],
                                                permissions: [
                                                    "contact:form-submissions:read",
                                                    "contact:form-submissions:delete",
                                                ]
                                            )
                                        ).html()
                                    }
                                }
                            }
                        }
                        .class("cms-table", "action-table")
                        .if(canRemove) { $0.class("select-table") }
                    ).html()
                ).html()
            }
        }
        .class("cms-section")
    }

    private var hasEmailColumn: Bool {
        items.contains { $0.email != nil }
    }
}
