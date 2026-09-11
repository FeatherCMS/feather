import AnalyticsAdminAPI
import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct AnalyticsLogDetails: Component {

    struct State {
        let log: Components.Schemas.AnalyticsLogDetailSchema
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminDetailFieldStyleAnchor())
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("Analytics log details")
            context.render(AdminDetailsField(label: "ID", value: state.log.id))
            context.render(AdminDetailsField(
                label: "Account ID",
                value: display(state.log.accountId)
            ))
            context.render(AdminDetailsField(label: "Source", value: state.log.source))
            context.render(AdminDetailsField(label: "Method", value: state.log.method))
            context.render(AdminDetailsField(
                label: "Status",
                value: "\(state.log.responseCode)"
            ))
            context.render(AdminDetailsField(label: "Path", value: state.log.path))
            context.render(AdminDetailsField(label: "URL", value: state.log.url))
            context.render(AdminDetailsField(label: "IP", value: display(state.log.ip)))
            context.render(AdminDetailsField(
                label: "Referer",
                value: display(state.log.referer)
            ))
            context.render(AdminDetailsField(label: "Origin", value: display(state.log.origin)))
            context.render(AdminDetailsField(
                label: "Accept-Language",
                value: display(state.log.acceptLanguage)
            ))
            context.render(AdminDetailsField(
                label: "User-Agent",
                value: display(state.log.userAgent)
            ))
            context.render(AdminDetailsField(
                label: "Language",
                value: display(state.log.language)
            ))
            context.render(AdminDetailsField(label: "Region", value: display(state.log.region)))
            context.render(AdminDetailsField(
                label: "OS Name",
                value: display(state.log.osName)
            ))
            context.render(AdminDetailsField(
                label: "OS Version",
                value: display(state.log.osVersion)
            ))
            context.render(AdminDetailsField(
                label: "Browser Name",
                value: display(state.log.browserName)
            ))
            context.render(AdminDetailsField(
                label: "Browser Version",
                value: display(state.log.browserVersion)
            ))
            context.render(AdminDetailsField(
                label: "Engine Name",
                value: display(state.log.engineName)
            ))
            context.render(AdminDetailsField(
                label: "Engine Version",
                value: display(state.log.engineVersion)
            ))
            context.render(AdminDetailsField(
                label: "Device Vendor",
                value: display(state.log.deviceVendor)
            ))
            context.render(AdminDetailsField(
                label: "Device Type",
                value: display(state.log.deviceType)
            ))
            context.render(AdminDetailsField(
                label: "Device Model",
                value: display(state.log.deviceModel)
            ))
            context.render(AdminDetailsField(label: "CPU", value: display(state.log.cpu)))
            context.render(AdminDetailsField(
                label: "Created",
                value: DateFormatting.formatUnixTimestamp(state.log.createdAt)
            ))
            context.render(AdminDetailsField(
                label: "Updated",
                value: DateFormatting.formatUnixTimestamp(state.log.updatedAt)
            ))
            Div {
                P("Headers")
                    .class("admin-details-field__label")
                Pre(display(state.log.headers))
            }
            .class("admin-details-field")
        }
        .class("cms-section")
    }

    private func display(
        _ value: String?
    ) -> String {
        guard let value, !value.isEmpty else {
            return "N/A"
        }
        return value
    }
}
