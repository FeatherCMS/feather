import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct MediaProcessorDetailsView: Leaf {
    let item: Components.Schemas.MediaProcessorDetailSchema
    let breadcrumb: AdminBreadcrumb.State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb).html()
            H1("Processor details")
            AdminDetailsField(label: "ID", value: item.id).html()
            AdminDetailsField(label: "File suffix", value: item.name).html()
            AdminDetailsField(
                label: "Match extensions",
                value: item.matchExtensions
            ).html()
            AdminDetailsField(
                label: "Command template",
                value: item.commandTemplate
            ).html()
            AdminDetailsField(
                label: "Active",
                value: item.isActive ? "Yes" : "No"
            ).html()
            Div {
                AdminNavigationButton(
                    "Edit processor",
                    href: "/admin/media/processors/\(item.id)/edit/"
                ).html()
                AdminNavigationButton(
                    "Remove processor",
                    href: "/admin/media/processors/\(item.id)/remove/",
                    classes: ["danger"]
                ).html()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
