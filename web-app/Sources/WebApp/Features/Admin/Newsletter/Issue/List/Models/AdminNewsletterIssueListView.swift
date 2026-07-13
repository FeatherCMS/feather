import HTML
import SGML
import WebStandards

struct AdminNewsletterIssueListView: Component {
    struct State {
        let newsletterId: String
        let items: [AdminNewsletterIssueListItem]
        let error: String?
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminNewsletterCampaignTabs(campaignId: state.newsletterId, active: .issues)
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Campaign issues")
            if let error = state.error { P(error).class("error") }
            Div { AdminNavigationButton("Add issue", href: "/admin/newsletters/\(state.newsletterId)/issues/add/") }.class("button-row")
            Br(); Br()
            if state.items.isEmpty {
                P("No issues yet.")
            } else {
                ListTableShell(table: Table {
                    Thead { Tr { Th("Subject"); Th("Status"); Th("Scheduled"); Th("Created") } }
                    Tbody {
                        for item in state.items {
                            Tr {
                                Td(item.subject).data("label", "Subject")
                                Td(item.status).data("label", "Status")
                                Td(item.scheduledAt).data("label", "Scheduled")
                                Td(item.createdAt).data("label", "Created")
                            }
                        }
                    }
                }.class("cms-table"))
            }
        }.class("cms-section")
    }
}
