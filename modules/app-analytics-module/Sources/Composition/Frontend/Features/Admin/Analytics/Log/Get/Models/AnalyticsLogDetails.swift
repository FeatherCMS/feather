import AnalyticsAdminAPI
import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct AnalyticsLogDetails: Leaf {

    struct State {
        let log: Components.Schemas.AnalyticsLogDetailSchema
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            AdminDetailFieldStyleAnchor().html()
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1("Analytics log details")
            AdminDetailsField(label: "ID", value: state.log.id).html()
            AdminDetailsField(
                label: "Account ID",
                value: display(state.log.accountId)
            ).html()
            AdminDetailsField(label: "Source", value: state.log.source).html()
            AdminDetailsField(label: "Method", value: state.log.method).html()
            AdminDetailsField(
                label: "Status",
                value: "\(state.log.responseCode)"
            ).html()
            AdminDetailsField(label: "Path", value: state.log.path).html()
            AdminDetailsField(label: "URL", value: state.log.url).html()
            AdminDetailsField(label: "IP", value: display(state.log.ip)).html()
            AdminDetailsField(
                label: "Referer",
                value: display(state.log.referer)
            ).html()
            AdminDetailsField(label: "Origin", value: display(state.log.origin)).html()
            AdminDetailsField(
                label: "Accept-Language",
                value: display(state.log.acceptLanguage)
            ).html()
            AdminDetailsField(
                label: "User-Agent",
                value: display(state.log.userAgent)
            ).html()
            AdminDetailsField(
                label: "Language",
                value: display(state.log.language)
            ).html()
            AdminDetailsField(label: "Region", value: display(state.log.region)).html()
            AdminDetailsField(
                label: "OS Name",
                value: display(state.log.osName)
            ).html()
            AdminDetailsField(
                label: "OS Version",
                value: display(state.log.osVersion)
            ).html()
            AdminDetailsField(
                label: "Browser Name",
                value: display(state.log.browserName)
            ).html()
            AdminDetailsField(
                label: "Browser Version",
                value: display(state.log.browserVersion)
            ).html()
            AdminDetailsField(
                label: "Engine Name",
                value: display(state.log.engineName)
            ).html()
            AdminDetailsField(
                label: "Engine Version",
                value: display(state.log.engineVersion)
            ).html()
            AdminDetailsField(
                label: "Device Vendor",
                value: display(state.log.deviceVendor)
            ).html()
            AdminDetailsField(
                label: "Device Type",
                value: display(state.log.deviceType)
            ).html()
            AdminDetailsField(
                label: "Device Model",
                value: display(state.log.deviceModel)
            ).html()
            AdminDetailsField(label: "CPU", value: display(state.log.cpu)).html()
            AdminDetailsField(
                label: "Created",
                value: DateFormatting.formatUnixTimestamp(state.log.createdAt)
            ).html()
            AdminDetailsField(
                label: "Updated",
                value: DateFormatting.formatUnixTimestamp(state.log.updatedAt)
            ).html()
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
