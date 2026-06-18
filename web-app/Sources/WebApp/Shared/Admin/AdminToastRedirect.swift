import Foundation
import Hummingbird

struct AdminToastRedirect {
    struct Payload {
        let type: String
        let title: String
        let message: String
        let position: String
    }

    private static let typeKey = "toastType"
    private static let titleKey = "toastTitle"
    private static let messageKey = "toastMessage"
    private static let positionKey = "toastPosition"

    static func payload(
        from request: Request
    ) -> Payload? {
        guard
            let type = request.queryString(typeKey)?.nilIfEmpty,
            let title = request.queryString(titleKey)?.nilIfEmpty,
            let message = request.queryString(messageKey)?.nilIfEmpty
        else {
            return nil
        }
        return .init(
            type: type,
            title: title,
            message: message,
            position: request.queryString(positionKey)?.nilIfEmpty
                ?? "top-right"
        )
    }

    static func location(
        defaultPath: String,
        returnTo: String? = nil,
        title: String = "Success",
        message: String,
        type: String = "success",
        position: String = "top-right",
        extraQueryItems: [URLQueryItem] = []
    ) -> String {
        let base = returnTo ?? defaultPath
        guard var components = URLComponents(string: base) else {
            return fallbackLocation(
                defaultPath: defaultPath,
                title: title,
                message: message,
                type: type,
                position: position,
                extraQueryItems: extraQueryItems
            )
        }
        var queryItems = components.queryItems ?? []
        queryItems.removeAll {
            [
                typeKey,
                titleKey,
                messageKey,
                positionKey,
            ]
            .contains($0.name)
        }
        queryItems.append(contentsOf: extraQueryItems)
        queryItems.append(.init(name: typeKey, value: type))
        queryItems.append(.init(name: titleKey, value: title))
        queryItems.append(.init(name: messageKey, value: message))
        queryItems.append(.init(name: positionKey, value: position))
        components.queryItems = queryItems
        return components.string
            ?? fallbackLocation(
                defaultPath: defaultPath,
                title: title,
                message: message,
                type: type,
                position: position,
                extraQueryItems: extraQueryItems
            )
    }

    private static func fallbackLocation(
        defaultPath: String,
        title: String,
        message: String,
        type: String,
        position: String,
        extraQueryItems: [URLQueryItem]
    ) -> String {
        var queryItems = extraQueryItems
        queryItems.append(.init(name: typeKey, value: type))
        queryItems.append(.init(name: titleKey, value: title))
        queryItems.append(.init(name: messageKey, value: message))
        queryItems.append(.init(name: positionKey, value: position))
        let query =
            queryItems
            .compactMap { item -> String? in
                guard let value = item.value else { return nil }
                return "\(item.name)=\(value.queryEncoded())"
            }
            .joined(separator: "&")
        return query.isEmpty ? defaultPath : "\(defaultPath)?\(query)"
    }
}
