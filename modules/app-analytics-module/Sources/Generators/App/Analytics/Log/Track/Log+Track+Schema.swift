import FeatherOpenAPI

extension Analytics.Log.Track {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AppAnalyticsLogTrackSchema" }
        var propertyMap: SchemaMap {
            [
                "method": Schemas.Method(),
                "url": Schemas.URL(),
                "headers": Schemas.Headers(),
                "ip": Schemas.IP(),
                "path": Schemas.Path(),
                "referer": Schemas.Referer(),
                "origin": Schemas.Origin(),
                "acceptLanguage": Schemas.AcceptLanguage(),
                "userAgent": Schemas.UserAgent(),
                "responseCode": Schemas.ResponseCode(),
            ]
        }
    }
}
