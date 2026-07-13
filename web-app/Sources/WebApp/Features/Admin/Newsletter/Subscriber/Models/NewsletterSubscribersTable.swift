import HTML
import SGML
import WebStandards

struct NewsletterSubscribersTable: Component {
    struct State {
        let newsletterId: String
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let items: [AdminManageNewsletterSubscriberItem]
        let search: String
        let canRemove: Bool
        let error: String?
        let breadcrumb: AdminBreadcrumb.State
    }
    let state: State

    func content() -> some BasicTag {
        Section {
            AdminNewsletterCampaignTabs(campaignId: state.newsletterId, active: .subscribers)
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Campaign subscribers")
            if let error = state.error { P(error).class("error") }
            if state.isAdded { P("Subscriber added successfully.") }
            if state.isEdited { P("Subscriber edited successfully.") }
            if state.isRemoved { P("Subscriber removed successfully.") }
            Div { AdminNavigationButton("Add subscriber", href: "/admin/newsletters/\(state.newsletterId)/subscribers/add/") }.class("button-row")
            Br(); Br()
            ListTableSearchForm(state: .init(action: "/admin/newsletters/\(state.newsletterId)/subscribers/", placeholder: "Quick search subscribers", search: state.search))
            if state.items.isEmpty { P(state.search.isEmpty ? "No subscribers yet." : "No subscribers match your search.") } else {
                ListTableBulkRemoveForm(
                    state: .init(action: "/admin/newsletters/\(state.newsletterId)/subscribers/bulk-remove/", page: 1, search: state.search, canRemove: state.canRemove, buttonTitle: "Remove selected"),
                    table: ListTableShell(table: Table {
                        Thead { Tr { if state.canRemove { ListTableSelectAllCheckbox() }; Th("Email"); Th("Name"); Th("Status"); Th("Actions") } }
                        Tbody { for item in state.items { Tr { if state.canRemove { ListTableRowSelectCheckbox(state: .init(id: item.email)) }; Td(item.email).data("label", "Email"); Td("\(item.firstName) \(item.lastName)").data("label", "Name"); Td(item.status).data("label", "Status"); ListTableRowActions(state: .init(label: "Actions", actions: [.init(title: "Edit", href: "/admin/newsletters/\(state.newsletterId)/subscribers/\(item.email)/edit/", className: "edit", permission: "newsletter:subscribers:update"), .init(title: "Remove", href: "/admin/newsletters/\(state.newsletterId)/subscribers/\(item.email)/remove/", className: "delete", permission: "newsletter:subscribers:delete")], permissions: ["newsletter:subscribers:update", "newsletter:subscribers:delete"])) } } }
                    }.class("cms-table", "action-table").if(state.canRemove) { $0.class("bulk-select-table") })
                )
            }
        }.class("cms-section")
    }
}
