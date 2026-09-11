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

struct MediaProcessorDetailsView: Component {
    let item: Components.Schemas.MediaProcessorDetailSchema
    let breadcrumb: AdminBreadcrumb.State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: breadcrumb))
            H1("Processor details")
            context.render(AdminDetailsField(label: "ID", value: item.id))
            context.render(AdminDetailsField(label: "File suffix", value: item.name))
            context.render(AdminDetailsField(
                label: "Match extensions",
                value: item.matchExtensions
            ))
            context.render(AdminDetailsField(
                label: "Command template",
                value: item.commandTemplate
            ))
            context.render(AdminDetailsField(
                label: "Active",
                value: item.isActive ? "Yes" : "No"
            ))
            Div {
                context.render(AdminNavigationButton(
                    "Edit processor",
                    href: "/admin/media/processors/\(item.id)/edit/"
                ))
                context.render(AdminNavigationButton(
                    "Remove processor",
                    href: "/admin/media/processors/\(item.id)/remove/",
                    classes: ["danger"]
                ))
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
