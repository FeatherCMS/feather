import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct NewsletterCampaignSubscribersTable: Leaf {
    struct State {
        let newsletterId: String
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let items: [AdminNewsletterCampaignSubscriberItem]
        let search: String
        let canRemove: Bool
        let error: String?
        let breadcrumb: AdminBreadcrumb.State
    }
    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminNewsletterCampaignTabs(
                campaignId: state.newsletterId,
                active: .subscribers
            ).renderHTML()
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("Campaign subscribers")
            if let error = state.error { P(error).class("error") }
            if state.isAdded { P("Subscriber added successfully.") }
            if state.isEdited { P("Subscriber edited successfully.") }
            if state.isRemoved { P("Subscriber removed successfully.") }
            Div {
                AdminNavigationButton(
                    "Add subscriber",
                    href:
                        "/admin/newsletters/\(state.newsletterId)/subscribers/add/"
                ).renderHTML()
            }
            .class("button-row")
            Br()
            Br()
            ListTableSearchForm(
                state: .init(
                    action:
                        "/admin/newsletters/\(state.newsletterId)/subscribers/",
                    placeholder: "Quick search subscribers",
                    search: state.search
                )
            ).renderHTML()
            if state.items.isEmpty {
                P(
                    state.search.isEmpty
                        ? "No subscribers yet."
                        : "No subscribers match your search."
                )
            }
            else {
                ListTableRemoveForm(
                    state: .init(
                        action:
                            "/admin/newsletters/\(state.newsletterId)/subscribers/remove/",
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
                                        ListTableSelectAllCheckbox().renderHTML()
                                    }
                                    Th("Email")
                                    Th("Name")
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
                                            ).renderHTML()
                                        }
                                        Td(item.email).data("label", "Email")
                                        Td("\(item.firstName) \(item.lastName)")
                                            .data("label", "Name")
                                        Td(item.status).data("label", "Status")
                                        ListTableRowActions(
                                            state: .init(
                                                label: "Actions",
                                                actions: [
                                                    .init(
                                                        title: "Edit",
                                                        href:
                                                            "/admin/newsletters/\(state.newsletterId)/subscribers/\(item.id)/edit/",
                                                        className: "edit",
                                                        permission:
                                                            "newsletter:subscribers:update"
                                                    ),
                                                    .init(
                                                        title: "Remove",
                                                        href:
                                                            "/admin/newsletters/\(state.newsletterId)/subscribers/\(item.id)/remove/",
                                                        className: "delete",
                                                        permission:
                                                            "newsletter:subscribers:delete"
                                                    ),
                                                ],
                                                permissions: [
                                                    "newsletter:subscribers:update",
                                                    "newsletter:subscribers:delete",
                                                ]
                                            )
                                        ).renderHTML()
                                    }
                                }
                            }
                        }
                        .class("cms-table", "action-table")
                        .if(state.canRemove) { $0.class("select-table") }
                    ).renderHTML()
                ).renderHTML()
            }
        }
        .class("cms-section")
    }
}
