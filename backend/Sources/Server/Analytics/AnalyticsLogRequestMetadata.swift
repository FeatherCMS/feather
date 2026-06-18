import Foundation

enum AnalyticsLogRequestMetadata {

    static func headersJSONString(
        _ headers: [String: String]
    ) -> String {
        let headersData =
            (try? JSONSerialization.data(withJSONObject: headers))
            ?? Data("{}".utf8)
        return String(data: headersData, encoding: .utf8) ?? "{}"
    }

    static func parseAcceptLanguage(
        _ value: String?
    ) -> (language: String?, region: String?) {
        guard let value, let first = value.split(separator: ",").first else {
            return (nil, nil)
        }
        let code =
            first
            .split(separator: ";", maxSplits: 1)
            .first?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard let code, !code.isEmpty else {
            return (nil, nil)
        }
        let parts = code.split(separator: "-", maxSplits: 1).map(String.init)
        let language = parts.first?.lowercased()
        let region = parts.count > 1 ? parts[1].uppercased() : nil
        return (language, region)
    }

    static func parseUserAgent(
        _ value: String?
    ) -> (
        osName: String?, osVersion: String?, browserName: String?,
        browserVersion: String?, engineName: String?, engineVersion: String?,
        deviceVendor: String?, deviceType: String?, deviceModel: String?,
        cpu: String?
    ) {
        guard let value, !value.isEmpty else {
            return (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil)
        }

        let lowercased = value.lowercased()

        let browserName: String?
        if lowercased.contains("firefox/") {
            browserName = "Firefox"
        }
        else if lowercased.contains("edg/") {
            browserName = "Edge"
        }
        else if lowercased.contains("chrome/") {
            browserName = "Chrome"
        }
        else if lowercased.contains("safari/") {
            browserName = "Safari"
        }
        else {
            browserName = nil
        }

        let osName: String?
        if lowercased.contains("iphone") || lowercased.contains("ipad") {
            osName = "iOS"
        }
        else if lowercased.contains("mac os x") {
            osName = "macOS"
        }
        else if lowercased.contains("android") {
            osName = "Android"
        }
        else if lowercased.contains("windows") {
            osName = "Windows"
        }
        else if lowercased.contains("linux") {
            osName = "Linux"
        }
        else {
            osName = nil
        }

        let deviceType: String?
        if lowercased.contains("mobile") || lowercased.contains("iphone") {
            deviceType = "mobile"
        }
        else if lowercased.contains("ipad") || lowercased.contains("tablet") {
            deviceType = "tablet"
        }
        else {
            deviceType = "desktop"
        }

        return (
            osName,
            nil,
            browserName,
            nil,
            nil,
            nil,
            nil,
            deviceType,
            nil,
            nil
        )
    }
}
