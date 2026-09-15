import Foundation
import Hummingbird

/// Deprecated compatibility wrapper for the former toast redirect helper.
@available(*, deprecated, message: "Use AdminNotificationRedirect instead.")
public struct AdminToastRedirect {
    public typealias Payload = AdminNotificationRedirect.Payload

    public static func payload(from request: Request) -> Payload? {
        AdminNotificationRedirect.payload(from: request)
    }

    public static func location(
        defaultPath: String,
        returnTo: String? = nil,
        title: String = "Success",
        message: String,
        type: String = "success",
        position: String = "top-right",
        extraQueryItems: [URLQueryItem] = []
    ) -> String {
        AdminNotificationRedirect.location(
            defaultPath: defaultPath,
            returnTo: returnTo,
            title: title,
            message: message,
            type: type,
            position: position,
            extraQueryItems: extraQueryItems
        )
    }
}
