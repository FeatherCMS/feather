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

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb).renderHTML()
            H1("Processor details")
            AdminDetailsField(label: "ID", value: item.id).renderHTML()
            AdminDetailsField(label: "File suffix", value: item.name).renderHTML()
            AdminDetailsField(
                label: "Match extensions",
                value: item.matchExtensions
            ).renderHTML()
            AdminDetailsField(
                label: "Command template",
                value: item.commandTemplate
            ).renderHTML()
            AdminDetailsField(
                label: "Active",
                value: item.isActive ? "Yes" : "No"
            ).renderHTML()
            Div {
                AdminNavigationButton(
                    "Edit processor",
                    href: "/admin/media/processors/\(item.id)/edit/"
                ).renderHTML()
                AdminNavigationButton(
                    "Remove processor",
                    href: "/admin/media/processors/\(item.id)/remove/",
                    classes: ["danger"]
                ).renderHTML()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
