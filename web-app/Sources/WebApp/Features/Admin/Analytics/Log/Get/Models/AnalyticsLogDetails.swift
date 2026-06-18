import AdminOpenAPI
import HTML
import SGML
import WebStandards

struct AnalyticsLogDetails: Component {

    struct State {
        let log: Components.Schemas.AnalyticsLogDetailSchema
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminDetailFieldStyleAnchor()
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Analytics log details")
            AdminDetailsField(label: "ID", value: state.log.id)
            AdminDetailsField(
                label: "Account ID",
                value: display(state.log.accountId)
            )
            AdminDetailsField(label: "Source", value: state.log.source)
            AdminDetailsField(label: "Method", value: state.log.method)
            AdminDetailsField(
                label: "Status",
                value: "\(state.log.responseCode)"
            )
            AdminDetailsField(label: "Path", value: state.log.path)
            AdminDetailsField(label: "URL", value: state.log.url)
            AdminDetailsField(label: "IP", value: display(state.log.ip))
            AdminDetailsField(
                label: "Referer",
                value: display(state.log.referer)
            )
            AdminDetailsField(label: "Origin", value: display(state.log.origin))
            AdminDetailsField(
                label: "Accept-Language",
                value: display(state.log.acceptLanguage)
            )
            AdminDetailsField(
                label: "User-Agent",
                value: display(state.log.userAgent)
            )
            AdminDetailsField(
                label: "Language",
                value: display(state.log.language)
            )
            AdminDetailsField(label: "Region", value: display(state.log.region))
            AdminDetailsField(
                label: "OS Name",
                value: display(state.log.osName)
            )
            AdminDetailsField(
                label: "OS Version",
                value: display(state.log.osVersion)
            )
            AdminDetailsField(
                label: "Browser Name",
                value: display(state.log.browserName)
            )
            AdminDetailsField(
                label: "Browser Version",
                value: display(state.log.browserVersion)
            )
            AdminDetailsField(
                label: "Engine Name",
                value: display(state.log.engineName)
            )
            AdminDetailsField(
                label: "Engine Version",
                value: display(state.log.engineVersion)
            )
            AdminDetailsField(
                label: "Device Vendor",
                value: display(state.log.deviceVendor)
            )
            AdminDetailsField(
                label: "Device Type",
                value: display(state.log.deviceType)
            )
            AdminDetailsField(
                label: "Device Model",
                value: display(state.log.deviceModel)
            )
            AdminDetailsField(label: "CPU", value: display(state.log.cpu))
            AdminDetailsField(
                label: "Created",
                value: DateFormatting.formatUnixTimestamp(state.log.createdAt)
            )
            AdminDetailsField(
                label: "Updated",
                value: DateFormatting.formatUnixTimestamp(state.log.updatedAt)
            )
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
