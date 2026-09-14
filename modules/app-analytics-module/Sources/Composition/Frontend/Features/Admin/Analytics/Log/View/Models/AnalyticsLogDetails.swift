import AnalyticsAdminAPI
import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AnalyticsLogDetails: Component {
    let log: Components.Schemas.AnalyticsLogDetailSchema
    let breadcrumb: [NewAdminBreadcrumb.Link]

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(
                NewAdminDetailView(
                    breadcrumb: breadcrumb,
                    pageHeader: .init(
                        title: "Analytics log details",
                        description: "Inspect the recorded request metadata."
                    ),
                    fields: [
                        .init(label: "ID", value: log.id),
                        .init(
                            label: "Account ID",
                            value: display(log.accountId)
                        ),
                        .init(label: "Source", value: log.source),
                        .init(label: "Method", value: log.method),
                        .init(label: "Status", value: "\(log.responseCode)"),
                        .init(label: "Path", value: log.path),
                        .init(label: "URL", value: log.url),
                        .init(label: "IP", value: display(log.ip)),
                        .init(label: "Referer", value: display(log.referer)),
                        .init(label: "Origin", value: display(log.origin)),
                        .init(
                            label: "Accept-Language",
                            value: display(log.acceptLanguage)
                        ),
                        .init(
                            label: "User-Agent",
                            value: display(log.userAgent)
                        ),
                        .init(label: "Language", value: display(log.language)),
                        .init(label: "Region", value: display(log.region)),
                        .init(label: "OS Name", value: display(log.osName)),
                        .init(
                            label: "OS Version",
                            value: display(log.osVersion)
                        ),
                        .init(
                            label: "Browser Name",
                            value: display(log.browserName)
                        ),
                        .init(
                            label: "Browser Version",
                            value: display(log.browserVersion)
                        ),
                        .init(
                            label: "Engine Name",
                            value: display(log.engineName)
                        ),
                        .init(
                            label: "Engine Version",
                            value: display(log.engineVersion)
                        ),
                        .init(
                            label: "Device Vendor",
                            value: display(log.deviceVendor)
                        ),
                        .init(
                            label: "Device Type",
                            value: display(log.deviceType)
                        ),
                        .init(
                            label: "Device Model",
                            value: display(log.deviceModel)
                        ),
                        .init(label: "CPU", value: display(log.cpu)),
                        .init(
                            label: "Created",
                            value: DateFormatting.formatUnixTimestamp(
                                log.createdAt
                            )
                        ),
                        .init(
                            label: "Updated",
                            value: DateFormatting.formatUnixTimestamp(
                                log.updatedAt
                            )
                        ),
                    ]
                )
            )
            Div {
                P("Headers").class("admin-detail-view-field-label")
                Pre(display(log.headers))
            }
            .class("admin-detail-view-field")
        }
        .class("cms-section")
    }

    private func display(_ value: String?) -> String {
        guard let value, !value.isEmpty else { return "N/A" }
        return value
    }
}
