import Foundation
import Hummingbird

public enum ListBulkRemoveRedirect {

    public static func location(
        path: String,
        page: Int?,
        search: String?,
        queryItems extraQueryItems: [(String, String)] = [],
        title: String? = nil,
        message: String? = nil
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
        if let title, let message {
            return AdminToastRedirect.location(
                defaultPath: path,
                title: title,
                message: message,
                extraQueryItems: queryItems
            )
        }
        var components = URLComponents()
        components.path = path
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components.string ?? path
    }
}
