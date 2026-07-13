import HTML
import SGML
import WebStandards

struct AdminNewsletterSubscribersDirectoryView: Component {
    let model: AdminNewsletterSubscribersDirectoryModel
    let breadcrumb: AdminBreadcrumb.State
    let error: String?

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb)
            H1("Subscribers")
            Div { AdminNavigationButton("Add subscriber", href: "/admin/newsletters/subscribers/add/") }.class("button-row")
            Br(); Br()
            Form {
                Div {
                    Input().type(.search).name("search").value(model.search).placeholder("Quick search subscribers")
                    Select {
                        Option("All campaigns").value("").if(model.campaignId.isEmpty) { $0.selected() }
                        for campaign in model.campaigns {
                            Option(campaign.name).value(campaign.id).if(model.campaignId == campaign.id) { $0.selected() }
                        }
                    }.name("campaignId").style("min-width:20rem;")
                    Button("Search").type(.submit)
                    A("Reset").href("/admin/newsletters/subscribers/")
                }.class("table-search-form")
            }.method(.get).action("/admin/newsletters/subscribers/")
            if let error { P(error).class("error") }
            if model.items.isEmpty {
                P(model.search.isEmpty && model.campaignId.isEmpty ? "No subscribers found." : "No subscribers match your search.")
            } else {
                ListTableShell(table: Table {
                    Thead { Tr { Th("Email"); Th("Name"); Th("Newsletters") } }
                    Tbody {
                        for item in model.items {
                            Tr {
                                Td(item.email).data("label", "Email")
                                Td(item.name).data("label", "Name")
                                Td {
                                    for newsletter in item.newsletters {
                                        A("\(newsletter.name) (\(newsletter.status))")
                                            .href("/admin/newsletters/\(newsletter.id)/subscribers/")
                                        Br()
                                    }
                                }.data("label", "Newsletters")
                            }
                        }
                    }
                }.class("cms-table"))
            }
        }.class("cms-section")
    }
}
