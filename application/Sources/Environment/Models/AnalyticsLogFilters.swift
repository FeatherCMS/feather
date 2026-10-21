public import AnalyticsContracts
import Foundation

public struct WebAppAnalyticsLogFilter: AnalyticsLogFilter {
    private let common = CommonAnalyticsLogFilter()

    public init() {}

    public func shouldTrack(
        path: String,
        method: String,
        responseCode: Int
    ) -> Bool {
        let path = path.lowercased()
        guard !common.shouldIgnore(path: path) else { return false }

        if responseCode >= 400 || method == "GET" {
            return true
        }

        let normalizedPath = path.trimmingCharacters(
            in: CharacterSet(charactersIn: "/")
        )
        return method == "POST" && normalizedPath == "search"
    }
}

public struct BackendAPIAnalyticsLogFilter: AnalyticsLogFilter {
    private let common = CommonAnalyticsLogFilter()

    public init() {}

    public func shouldTrack(
        path: String,
        method: String,
        responseCode: Int
    ) -> Bool {
        let path = path.lowercased()
        guard !common.shouldIgnore(path: path) else { return false }
        guard
            !path.hasPrefix("/api/v1/admin/analytics/"),
            path != "/api/v1/analytics/logs/track"
        else {
            return false
        }

        return responseCode >= 400
            || (300..<400).contains(responseCode)
            || ["POST", "PUT", "PATCH", "DELETE"].contains(method)
    }
}

private struct CommonAnalyticsLogFilter: Sendable {
    private let ignoredExactPaths: Set<String> = [
        "/health", "/robots.txt", "/favicon.ico",
    ]
    private let ignoredPathFragments = [
        "/.env", "/.git", "/.svn", "/wp-", "/wp/", "/wordpress",
        "/xmlrpc.php", "/phpmyadmin", "/cgi-bin/",
    ]
    private let staticAssetExtensions: Set<String> = [
        ".css", ".js", ".mjs", ".map", ".png", ".jpg", ".jpeg",
        ".gif", ".svg", ".webp", ".ico", ".woff", ".woff2", ".ttf",
        ".eot", ".avif",
    ]

    func shouldIgnore(path: String) -> Bool {
        ignoredExactPaths.contains(path)
            || ignoredPathFragments.contains(where: path.contains)
            || staticAssetExtensions.contains(where: path.hasSuffix)
    }
}
