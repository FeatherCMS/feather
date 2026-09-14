import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminContactSubmissionsDirectoryView: Component {
    let items: [AdminContactSubmissionDirectoryItem]
    let search: String
    let canRemove: Bool
    let breadcrumb: AdminBreadcrumb.State
    let error: String?

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: breadcrumb))
            H1("Submissions")
            P("All contact form submissions.")
            if let error { P(error).class("error") }
            context.render(
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/contact/submissions/",
                        placeholder: "Quick search contact submissions",
                        search: search
                    )
                )
            )
            if items.isEmpty {
                P(
                    search.isEmpty
                        ? "No submissions yet."
                        : "No submissions match your search."
                )
            }
            else {
                context.render(
                    ListTableRemoveForm(
                        state: .init(
                            action: "/admin/contact/submissions/remove/",
                            page: 1,
                            search: search,
                            canRemove: canRemove,
                            buttonTitle: "Remove selected"
                        ),
                        table: context.render(
                            ListTableShell(
                                table: Table {
                                    Thead {
                                        Tr {
                                            if canRemove {
                                                context.render(
                                                    ListTableSelectAllCheckbox()
                                                )
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
                                                    context.render(
                                                        ListTableRowSelectCheckbox(
                                                            state: .init(
                                                                id:
                                                                    "\(item.formId):\(item.id)"
                                                            )
                                                        )
                                                    )
                                                }
                                                Td(item.formName)
                                                    .data("label", "Form")
                                                Td(item.createdAt)
                                                    .data("label", "Submitted")
                                                if hasEmailColumn {
                                                    Td(item.email ?? "—")
                                                        .data("label", "Email")
                                                }
                                                Td(item.status)
                                                    .data("label", "Status")
                                                context.render(
                                                    ListTableRowActions(
                                                        state: .init(
                                                            label: "Actions",
                                                            actions: [
                                                                .init(
                                                                    title:
                                                                        "Details",
                                                                    href:
                                                                        "/admin/contact/forms/\(item.formId)/submissions/\(item.id)/",
                                                                    className:
                                                                        nil,
                                                                    permission:
                                                                        "contact:form-submissions:read"
                                                                ),
                                                                .init(
                                                                    title:
                                                                        "Remove",
                                                                    href:
                                                                        "/admin/contact/forms/\(item.formId)/submissions/\(item.id)/remove/",
                                                                    className:
                                                                        "delete",
                                                                    permission:
                                                                        "contact:form-submissions:delete"
                                                                ),
                                                            ],
                                                            permissions: [
                                                                "contact:form-submissions:read",
                                                                "contact:form-submissions:delete",
                                                            ]
                                                        )
                                                    )
                                                )
                                            }
                                        }
                                    }
                                }
                                .class("cms-table", "action-table")
                                .if(canRemove) { $0.class("select-table") }
                            )
                        )
                    )
                )
            }
        }
        .class("cms-section")
    }

    private var hasEmailColumn: Bool {
        items.contains { $0.email != nil }
    }
}
