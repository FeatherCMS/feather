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

    func renderHTML() -> some BasicTag {
        Section {
            AdminDetailFieldStyleAnchor().renderHTML()
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("Analytics log details")
            AdminDetailsField(label: "ID", value: state.log.id).renderHTML()
            AdminDetailsField(
                label: "Account ID",
                value: display(state.log.accountId)
            ).renderHTML()
            AdminDetailsField(label: "Source", value: state.log.source).renderHTML()
            AdminDetailsField(label: "Method", value: state.log.method).renderHTML()
            AdminDetailsField(
                label: "Status",
                value: "\(state.log.responseCode)"
            ).renderHTML()
            AdminDetailsField(label: "Path", value: state.log.path).renderHTML()
            AdminDetailsField(label: "URL", value: state.log.url).renderHTML()
            AdminDetailsField(label: "IP", value: display(state.log.ip)).renderHTML()
            AdminDetailsField(
                label: "Referer",
                value: display(state.log.referer)
            ).renderHTML()
            AdminDetailsField(label: "Origin", value: display(state.log.origin)).renderHTML()
            AdminDetailsField(
                label: "Accept-Language",
                value: display(state.log.acceptLanguage)
            ).renderHTML()
            AdminDetailsField(
                label: "User-Agent",
                value: display(state.log.userAgent)
            ).renderHTML()
            AdminDetailsField(
                label: "Language",
                value: display(state.log.language)
            ).renderHTML()
            AdminDetailsField(label: "Region", value: display(state.log.region)).renderHTML()
            AdminDetailsField(
                label: "OS Name",
                value: display(state.log.osName)
            ).renderHTML()
            AdminDetailsField(
                label: "OS Version",
                value: display(state.log.osVersion)
            ).renderHTML()
            AdminDetailsField(
                label: "Browser Name",
                value: display(state.log.browserName)
            ).renderHTML()
            AdminDetailsField(
                label: "Browser Version",
                value: display(state.log.browserVersion)
            ).renderHTML()
            AdminDetailsField(
                label: "Engine Name",
                value: display(state.log.engineName)
            ).renderHTML()
            AdminDetailsField(
                label: "Engine Version",
                value: display(state.log.engineVersion)
            ).renderHTML()
            AdminDetailsField(
                label: "Device Vendor",
                value: display(state.log.deviceVendor)
            ).renderHTML()
            AdminDetailsField(
                label: "Device Type",
                value: display(state.log.deviceType)
            ).renderHTML()
            AdminDetailsField(
                label: "Device Model",
                value: display(state.log.deviceModel)
            ).renderHTML()
            AdminDetailsField(label: "CPU", value: display(state.log.cpu)).renderHTML()
            AdminDetailsField(
                label: "Created",
                value: DateFormatting.formatUnixTimestamp(state.log.createdAt)
            ).renderHTML()
            AdminDetailsField(
                label: "Updated",
                value: DateFormatting.formatUnixTimestamp(state.log.updatedAt)
            ).renderHTML()
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
