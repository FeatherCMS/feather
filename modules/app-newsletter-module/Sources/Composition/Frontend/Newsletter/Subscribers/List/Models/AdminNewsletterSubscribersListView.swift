import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminNewsletterSubscribersListView: Leaf {
    let model: AdminNewsletterSubscribersListModel
    let breadcrumb: AdminBreadcrumb.State
    let error: String?
    let canRemove: Bool

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb).html()
            H1("Subscribers")
            Div {
                AdminNavigationButton(
                    "Add subscriber",
                    href: "/admin/newsletters/subscribers/add/"
                ).html()
            }
            .class("button-row")
            Br()
            Br()
            Form {
                Div {
                    Input().type(.search).name("search").value(model.search)
                        .placeholder("Quick search subscribers")
                    Select {
                        Option("All campaigns").value("")
                            .if(model.campaignId.isEmpty) { $0.selected() }
                        for campaign in model.campaigns {
                            Option(campaign.name).value(campaign.id)
                                .if(model.campaignId == campaign.id) {
                                    $0.selected()
                                }
                        }
                    }
                    .name("campaignId").style("min-width:20rem;")
                    Button("Search").type(.submit)
                    A("Reset").href("/admin/newsletters/subscribers/")
                }
                .class("table-search-form")
            }
            .method(.get).action("/admin/newsletters/subscribers/")
            if let error { P(error).class("error") }
            if model.items.isEmpty {
                P(
                    model.search.isEmpty && model.campaignId.isEmpty
                        ? "No subscribers found."
                        : "No subscribers match your search."
                )
            }
            else {
                ListTableRemoveForm(
                    state: .init(
                        action: "/admin/newsletters/subscribers/remove/",
                        page: 1,
                        search: model.search,
                        canRemove: canRemove,
                        buttonTitle: "Remove selected",
                        queryItems: model.campaignId.isEmpty
                            ? [] : [("campaignId", model.campaignId)]
                    ),
                    table: ListTableShell(
                        table: Table {
                            Thead {
                                Tr {
                                    if canRemove {
                                        ListTableSelectAllCheckbox().html()
                                    }
                                    Th("Email")
                                    Th("Name")
                                    Th("Newsletters")
                                    Th("Actions")
                                }
                            }
                            Tbody {
                                for item in model.items {
                                    Tr {
                                        if canRemove {
                                            ListTableRowSelectCheckbox(
                                                state: .init(id: item.id)
                                            ).html()
                                        }
                                        Td(item.email).data("label", "Email")
                                        Td(item.name).data("label", "Name")
                                        Td {
                                            for newsletter in item.newsletters {
                                                A(
                                                    "\(newsletter.name) (\(newsletter.status))"
                                                )
                                                .href(
                                                    "/admin/newsletters/\(newsletter.id)/subscribers/"
                                                )
                                                Br()
                                            }
                                        }
                                        .data("label", "Newsletters")
                                        if let newsletter = item.newsletters
                                            .first
                                        {
                                            ListTableRowActions(
                                                state: .init(
                                                    label: "Actions",
                                                    actions: [
                                                        .init(
                                                            title: "Details",
                                                            href:
                                                                "/admin/newsletters/subscribers/\(item.id)/",
                                                            className: nil,
                                                            permission:
                                                                "newsletter:subscribers:read"
                                                        ),
                                                        .init(
                                                            title: "Edit",
                                                            href:
                                                                "/admin/newsletters/\(newsletter.id)/subscribers/\(item.id)/edit/",
                                                            className: "edit",
                                                            permission:
                                                                "newsletter:subscribers:update"
                                                        ),
                                                        .init(
                                                            title: "Remove",
                                                            href:
                                                                "/admin/newsletters/subscribers/remove/?selectedIds=\(item.id)",
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
                                            ).html()
                                        }
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
}
