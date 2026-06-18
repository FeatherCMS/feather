import AdminOpenAPI
import HTML
import SGML
import WebStandards

struct MediaProcessorDetailsView: Component {
    let item: Components.Schemas.MediaProcessorDetailSchema
    let breadcrumb: AdminBreadcrumb.State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb)
            H1("Processor details")
            AdminDetailsField(label: "ID", value: item.id)
            AdminDetailsField(label: "File suffix", value: item.name)
            AdminDetailsField(
                label: "Match extensions",
                value: item.matchExtensions
            )
            AdminDetailsField(
                label: "Command template",
                value: item.commandTemplate
            )
            AdminDetailsField(
                label: "Active",
                value: item.isActive ? "Yes" : "No"
            )
            Div {
                AdminNavigationButton(
                    "Edit processor",
                    href: "/admin/media/processors/\(item.id)/edit/"
                )
                AdminNavigationButton(
                    "Remove processor",
                    href: "/admin/media/processors/\(item.id)/remove/",
                    classes: ["danger"]
                )
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
