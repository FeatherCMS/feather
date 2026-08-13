import FeatherOpenAPI
import OpenAPIKit30

struct AppAnalyticsLogMethodField: StringSchemaRepresentable {
    var example: String? = "GET"
}

struct AppAnalyticsLogURLField: StringSchemaRepresentable {
    var example: String? = "/admin/user/accounts/?page=1"
}

struct AppAnalyticsLogHeadersField: StringSchemaRepresentable {
    var example: String? = #"{"accept":"text/html"}"#
}

struct AppAnalyticsLogIPField: StringSchemaRepresentable {
    var example: String? = "203.0.113.10"
}

struct AppAnalyticsLogPathField: StringSchemaRepresentable {
    var example: String? = "/admin/user/accounts/"
}

struct AppAnalyticsLogRefererField: StringSchemaRepresentable {
    var example: String? = "https://example.com/login"
}

struct AppAnalyticsLogOriginField: StringSchemaRepresentable {
    var example: String? = "https://example.com"
}

struct AppAnalyticsLogAcceptLanguageField: StringSchemaRepresentable {
    var example: String? = "en-US,en;q=0.9"
}

struct AppAnalyticsLogUserAgentField: StringSchemaRepresentable {
    var example: String? =
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"
}

struct AppAnalyticsLogResponseCodeField: IntSchemaRepresentable {
    var example: Int? = 200
}

struct AppAnalyticsLogTrackSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "method": AppAnalyticsLogMethodField(),
            "url": AppAnalyticsLogURLField(),
            "headers": AppAnalyticsLogHeadersField(),
            "ip": AppAnalyticsLogIPField(),
            "path": AppAnalyticsLogPathField(),
            "referer": AppAnalyticsLogRefererField(),
            "origin": AppAnalyticsLogOriginField(),
            "acceptLanguage": AppAnalyticsLogAcceptLanguageField(),
            "userAgent": AppAnalyticsLogUserAgentField(),
            "responseCode": AppAnalyticsLogResponseCodeField(),
        ]
    }
}
