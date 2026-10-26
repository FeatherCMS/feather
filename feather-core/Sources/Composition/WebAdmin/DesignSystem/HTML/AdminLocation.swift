public import Foundation

public struct AdminLocation: Sendable {

    public static func remove(
        path: String,
        ids: [String],
        returnTo: String
    ) -> String {
        var queryItems: [URLQueryItem] = []
        for id in ids {
            queryItems.append(.init(name: "ids", value: id))
        }
        queryItems.append(.init(name: "returnTo", value: returnTo))
        return url(
            path: path,
            queryItems: queryItems
        )
    }

    public static func removeCancel(
        path: String,
        returnTo: String?
    ) -> String {
        if let returnTo = validatedReturnTo(
            returnTo,
            allowedPathPrefix: path
        ) {
            return returnTo
        }
        return path
    }

    public static func url(
        path: String,
        page: Int? = nil,
        search: String? = nil,
        queryItems extraQueryItems: [URLQueryItem] = []
    ) -> String {
        var queryItems: [URLQueryItem] = []
        if let page {
            queryItems.append(.init(name: "page", value: String(page)))
        }
        if let search, !search.isEmpty {
            queryItems.append(.init(name: "search", value: search))
        }
        queryItems.append(contentsOf: extraQueryItems)
        var components = URLComponents()
        components.path = path
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components.string ?? path
    }

    private static func validatedReturnTo(
        _ returnTo: String?,
        allowedPathPrefix: String
    ) -> String? {
        guard
            let returnTo,
            let components = URLComponents(string: returnTo),
            components.scheme == nil,
            components.host == nil,
            isPath(
                components.path,
                within: allowedPathPrefix
            )
        else { return nil }
        return returnTo
    }

    private static func isPath(_ path: String, within prefix: String) -> Bool {
        path == prefix || path.hasPrefix(prefix + "/")
    }
}
