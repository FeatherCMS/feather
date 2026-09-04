import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct ContactFormSubmissionsTable: Leaf {
    struct State {
        let formId: String
        let items: [AdminContactFormSubmissionItem]
        let search: String
        let error: String?
        let breadcrumb: AdminBreadcrumb.State
        let canRemove: Bool
    }
    let state: State
    func html() -> some BasicTag {
        Section {
            AdminContactFormTabs(formId: state.formId, active: .submissions).html()
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1("Contact form submissions")
            if let error = state.error { P(error).class("error") }
            ListTableSearchForm(
                state: .init(
                    action: "/admin/contact/forms/\(state.formId)/submissions/",
                    placeholder: "Quick search submissions",
                    search: state.search
                )
            ).html()
            if state.items.isEmpty {
                P(
                    state.search.isEmpty
                        ? "No submissions yet."
                        : "No submissions match your search."
                )
            }
            else {
                ListTableRemoveForm(
                    state: .init(
                        action:
                            "/admin/contact/forms/\(state.formId)/submissions/remove/",
                        page: 1,
                        search: state.search,
                        canRemove: state.canRemove,
                        buttonTitle: "Remove selected"
                    ),
                    table: ListTableShell(
                        table: Table {
                            Thead {
                                Tr {
                                    if state.canRemove {
                                        ListTableSelectAllCheckbox().html()
                                    }
                                    Th("Submitted")
                                    if hasEmailColumn { Th("Email") }
                                    Th("Status")
                                    Th("Actions")
                                }
                            }
                            Tbody {
                                for item in state.items {
                                    Tr {
                                        if state.canRemove {
                                            ListTableRowSelectCheckbox(
                                                state: .init(id: item.id)
                                            ).html()
                                        }
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
                                                            "/admin/contact/forms/\(state.formId)/submissions/\(item.id)/",
                                                        className: nil,
                                                        permission:
                                                            "contact:form-submissions:read"
                                                    ),
                                                    .init(
                                                        title: "Remove",
                                                        href:
                                                            "/admin/contact/forms/\(state.formId)/submissions/\(item.id)/remove/",
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
                        .if(state.canRemove) { $0.class("select-table") }
                    ).html()
                ).html()
            }
        }
        .class("cms-section")
    }

    private var hasEmailColumn: Bool {
        state.items.contains { $0.email != nil }
    }
}
