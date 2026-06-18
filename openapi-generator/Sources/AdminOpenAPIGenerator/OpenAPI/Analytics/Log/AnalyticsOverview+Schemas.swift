import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

struct AnalyticsLogOverviewDateField: DoubleSchemaRepresentable {
    var example: Double? = 1_717_171_717
}

struct AnalyticsLogOverviewQuerySchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "source": AnalyticsLogSourceField(),
            "from": AnalyticsLogOverviewDateField(),
            "to": AnalyticsLogOverviewDateField(),
        ]
    }
}

struct AnalyticsLogOverviewKPIField: DoubleSchemaRepresentable {
    var example: Double? = 123
}

struct AnalyticsLogOverviewKPIIntField: IntSchemaRepresentable {
    var example: Int? = 123
}

struct AnalyticsLogOverviewKPISchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "totalRequests": AnalyticsLogOverviewKPIIntField(),
            "averageRequestsPerDay": AnalyticsLogOverviewKPIField(),
            "authenticatedRequests": AnalyticsLogOverviewKPIIntField(),
            "notFoundRequests": AnalyticsLogOverviewKPIIntField(),
            "clientErrorRequests": AnalyticsLogOverviewKPIIntField(),
            "serverErrorRequests": AnalyticsLogOverviewKPIIntField(),
        ]
    }
}

struct AnalyticsLogOverviewDailyPointSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "bucket": AnalyticsLogOverviewDateField(),
            "requests": AnalyticsLogOverviewKPIIntField(),
            "notFoundRequests": AnalyticsLogOverviewKPIIntField(),
            "clientErrorRequests": AnalyticsLogOverviewKPIIntField(),
            "serverErrorRequests": AnalyticsLogOverviewKPIIntField(),
        ]
    }
}

struct AnalyticsLogOverviewDailyListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        AnalyticsLogOverviewDailyPointSchema().reference()
    }
}

struct AnalyticsLogOverviewBreakdownItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "label": AnalyticsLogSearchField(),
            "count": AnalyticsLogOverviewKPIIntField(),
            "share": AnalyticsLogOverviewKPIField(),
        ]
    }
}

struct AnalyticsLogOverviewBreakdownListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        AnalyticsLogOverviewBreakdownItemSchema().reference()
    }
}

struct AnalyticsLogOverviewSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "query": AnalyticsLogOverviewQuerySchema().reference(),
            "kpis": AnalyticsLogOverviewKPISchema().reference(),
            "daily": AnalyticsLogOverviewDailyListSchema().reference(),
            "statusFamilies": AnalyticsLogOverviewBreakdownListSchema()
                .reference(),
            "methods": AnalyticsLogOverviewBreakdownListSchema().reference(),
            "paths": AnalyticsLogOverviewBreakdownListSchema().reference(),
            "notFoundPaths": AnalyticsLogOverviewBreakdownListSchema()
                .reference(),
            "serverErrorPaths": AnalyticsLogOverviewBreakdownListSchema()
                .reference(),
            "referrers": AnalyticsLogOverviewBreakdownListSchema().reference(),
            "browsers": AnalyticsLogOverviewBreakdownListSchema().reference(),
            "operatingSystems": AnalyticsLogOverviewBreakdownListSchema()
                .reference(),
            "deviceTypes": AnalyticsLogOverviewBreakdownListSchema()
                .reference(),
            "languages": AnalyticsLogOverviewBreakdownListSchema().reference(),
            "regions": AnalyticsLogOverviewBreakdownListSchema().reference(),
        ]
    }
}
