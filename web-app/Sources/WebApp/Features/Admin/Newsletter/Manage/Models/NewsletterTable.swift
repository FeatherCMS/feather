import HTML
import SGML
import WebStandards

struct NewsletterTable: Component {
    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let items: [AdminManageNewsletterItem]
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Campaigns")
            if state.isAdded { P("Campaign added successfully.") }
            if state.isEdited { P("Campaign edited successfully.") }
            if state.isRemoved { P("Campaign removed successfully.") }
            Div { AdminNavigationButton("Add campaign", href: "/admin/newsletters/add/") }.class("button-row")
            Br()
            Br()
            if state.items.isEmpty {
                P("No campaigns yet.")
            } else {
                ListTableShell(
                    table: Table {
                        Thead { Tr { Th("Name"); Th("Actions") } }
                        Tbody {
                            for item in state.items {
                                Tr {
                                    Td(item.name).data("label", "Name")
                                    ListTableRowActions(state: .init(label: "Actions", actions: [
                                        .init(title: "Subscribers", href: "/admin/newsletters/\(item.id)/subscribers/", className: nil, permission: "newsletter:subscribers:list"),
                                        .init(title: "Details", href: "/admin/newsletters/\(item.id)/details/", className: "edit", permission: "newsletter:campaigns:update"),
                                        .init(title: "Remove", href: "/admin/newsletters/\(item.id)/remove/", className: "delete", permission: "newsletter:campaigns:delete")
                                    ], permissions: ["newsletter:subscribers:list", "newsletter:campaigns:update", "newsletter:campaigns:delete"]))
                                }
                            }
                        }
                    }.class("cms-table", "action-table")
                )
            }
        }.class("cms-section")
    }
}
