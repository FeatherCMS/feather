import FeatherOpenAPI

extension Analytics.Log.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Analytics.Log.Schemas.ID().reference(),
                "accountId": Analytics.Log.Schemas.AccountID(),
                "source": Analytics.Log.Schemas.Source(),
                "method": Analytics.Log.Schemas.Method(),
                "url": Analytics.Log.Schemas.URL(),
                "headers": Analytics.Log.Schemas.Headers(),
                "ip": Analytics.Log.Schemas.IP(),
                "path": Analytics.Log.Schemas.Path(),
                "referer": Analytics.Log.Schemas.Referer(),
                "origin": Analytics.Log.Schemas.Origin(),
                "acceptLanguage": Analytics.Log.Schemas.AcceptLanguage(),
                "userAgent": Analytics.Log.Schemas.UserAgent(),
                "language": Analytics.Log.Schemas.Language(),
                "region": Analytics.Log.Schemas.Region(),
                "osName": Analytics.Log.Schemas.OSName(),
                "osVersion": Analytics.Log.Schemas.OSVersion(),
                "browserName": Analytics.Log.Schemas.BrowserName(),
                "browserVersion": Analytics.Log.Schemas.BrowserVersion(),
                "engineName": Analytics.Log.Schemas.EngineName(),
                "engineVersion": Analytics.Log.Schemas.EngineVersion(),
                "deviceVendor": Analytics.Log.Schemas.DeviceVendor(),
                "deviceType": Analytics.Log.Schemas.DeviceType(),
                "deviceModel": Analytics.Log.Schemas.DeviceModel(),
                "cpu": Analytics.Log.Schemas.CPU(),
                "responseCode": Analytics.Log.Schemas.ResponseCode(),
                "createdAt": Analytics.Log.Schemas.Timestamp(),
                "updatedAt": Analytics.Log.Schemas.Timestamp(),
            ]
        }
    }
}
