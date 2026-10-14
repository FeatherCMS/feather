import Foundation

public struct NewAdminLocation: Sendable {

    public static func remove(
        path: String,
        ids: [String],
        returnTo: String
    ) -> String {
        url(
            path: path,
            queryItems: ids.map { ("ids", $0) } + [("returnTo", returnTo)]
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
        queryItems extraQueryItems: [(String, String)] = []
    ) -> String {
        var queryItems: [URLQueryItem] = []
        if let page {
            queryItems.append(.init(name: "page", value: String(page)))
        }
        if let search, !search.isEmpty {
            queryItems.append(.init(name: "search", value: search))
        }
        queryItems.append(
            contentsOf: extraQueryItems.map {
                .init(name: $0.0, value: $0.1)
            }
        )
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
