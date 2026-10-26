import AnalyticsModule

extension Log.View {
    struct Model: Sendable {
        let id: String
        let accountId: String
        let source: String
        let method: String
        let url: String
        let headers: String
        let ip: String
        let path: String
        let referer: String
        let origin: String
        let acceptLanguage: String
        let userAgent: String
        let language: String
        let region: String
        let osName: String
        let osVersion: String
        let browserName: String
        let browserVersion: String
        let engineName: String
        let engineVersion: String
        let deviceVendor: String
        let deviceType: String
        let deviceModel: String
        let cpu: String
        let responseCode: Int
        let createdAt: Double
        let updatedAt: Double
    }
}
