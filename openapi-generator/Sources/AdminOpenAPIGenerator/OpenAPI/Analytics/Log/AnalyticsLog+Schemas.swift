import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

struct AnalyticsLogIdField: StringSchemaRepresentable {
    var example: String? = "analytics-log-01"
}

struct AnalyticsLogAccountIdField: StringSchemaRepresentable {
    var example: String? = "account-01"
}

struct AnalyticsLogMethodField: StringSchemaRepresentable {
    var example: String? = "GET"
}

struct AnalyticsLogSearchField: StringSchemaRepresentable {
    var example: String? = "chrome"
}

struct AnalyticsLogSourceField: StringSchemaRepresentable {
    var example: String? = "web_app"
}

struct AnalyticsLogPathField: StringSchemaRepresentable {
    var example: String? = "/articles/hello-world/"
}

struct AnalyticsLogResponseCodeField: IntSchemaRepresentable {
    var example: Int? = 200
}

struct AnalyticsLogIPField: StringSchemaRepresentable {
    var example: String? = "203.0.113.10"
}

struct AnalyticsLogBrowserNameField: StringSchemaRepresentable {
    var example: String? = "Safari"
}

struct AnalyticsLogTimestampField: DoubleSchemaRepresentable {
    var example: Double? = 1_717_171_717
}

struct AnalyticsLogURLField: StringSchemaRepresentable {
    var example: String? = "https://example.com/admin/analytics/logs/"
}

struct AnalyticsLogHeadersField: StringSchemaRepresentable {
    var example: String? = "{\"accept\":\"application/json\"}"
}

struct AnalyticsLogRefererField: StringSchemaRepresentable {
    var example: String? = "https://example.com/admin/"
}

struct AnalyticsLogOriginField: StringSchemaRepresentable {
    var example: String? = "https://example.com"
}

struct AnalyticsLogAcceptLanguageField: StringSchemaRepresentable {
    var example: String? = "en-US,en;q=0.9"
}

struct AnalyticsLogUserAgentField: StringSchemaRepresentable {
    var example: String? = "Mozilla/5.0"
}

struct AnalyticsLogLanguageField: StringSchemaRepresentable {
    var example: String? = "en"
}

struct AnalyticsLogRegionField: StringSchemaRepresentable {
    var example: String? = "US"
}

struct AnalyticsLogOSNameField: StringSchemaRepresentable {
    var example: String? = "macOS"
}

struct AnalyticsLogOSVersionField: StringSchemaRepresentable {
    var example: String? = "15.0"
}

struct AnalyticsLogBrowserVersionField: StringSchemaRepresentable {
    var example: String? = "17.5"
}

struct AnalyticsLogEngineNameField: StringSchemaRepresentable {
    var example: String? = "WebKit"
}

struct AnalyticsLogEngineVersionField: StringSchemaRepresentable {
    var example: String? = "617.1"
}

struct AnalyticsLogDeviceVendorField: StringSchemaRepresentable {
    var example: String? = "Apple"
}

struct AnalyticsLogDeviceTypeField: StringSchemaRepresentable {
    var example: String? = "desktop"
}

struct AnalyticsLogDeviceModelField: StringSchemaRepresentable {
    var example: String? = "Mac"
}

struct AnalyticsLogCPUField: StringSchemaRepresentable {
    var example: String? = "arm64"
}

struct AnalyticsLogListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": AnalyticsLogIdField().reference(),
            "accountId": AnalyticsLogAccountIdField(),
            "source": AnalyticsLogSourceField(),
            "method": AnalyticsLogMethodField(),
            "path": AnalyticsLogPathField(),
            "responseCode": AnalyticsLogResponseCodeField(),
            "ip": AnalyticsLogIPField(),
            "browserName": AnalyticsLogBrowserNameField(),
            "createdAt": AnalyticsLogTimestampField(),
        ]
    }
}

struct AnalyticsLogDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": AnalyticsLogIdField().reference(),
            "accountId": AnalyticsLogAccountIdField(),
            "source": AnalyticsLogSourceField(),
            "method": AnalyticsLogMethodField(),
            "url": AnalyticsLogURLField(),
            "headers": AnalyticsLogHeadersField(),
            "ip": AnalyticsLogIPField(),
            "path": AnalyticsLogPathField(),
            "referer": AnalyticsLogRefererField(),
            "origin": AnalyticsLogOriginField(),
            "acceptLanguage": AnalyticsLogAcceptLanguageField(),
            "userAgent": AnalyticsLogUserAgentField(),
            "language": AnalyticsLogLanguageField(),
            "region": AnalyticsLogRegionField(),
            "osName": AnalyticsLogOSNameField(),
            "osVersion": AnalyticsLogOSVersionField(),
            "browserName": AnalyticsLogBrowserNameField(),
            "browserVersion": AnalyticsLogBrowserVersionField(),
            "engineName": AnalyticsLogEngineNameField(),
            "engineVersion": AnalyticsLogEngineVersionField(),
            "deviceVendor": AnalyticsLogDeviceVendorField(),
            "deviceType": AnalyticsLogDeviceTypeField(),
            "deviceModel": AnalyticsLogDeviceModelField(),
            "cpu": AnalyticsLogCPUField(),
            "responseCode": AnalyticsLogResponseCodeField(),
            "createdAt": AnalyticsLogTimestampField(),
            "updatedAt": AnalyticsLogTimestampField(),
        ]
    }
}

struct AnalyticsLogFiltersSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "search": AnalyticsLogPathField().reference(required: false),
            "source": AnalyticsLogSourceField().reference(required: false),
            "method": AnalyticsLogMethodField().reference(required: false),
            "responseCode":
                AnalyticsLogResponseCodeField().reference(required: false),
        ]
    }
}
