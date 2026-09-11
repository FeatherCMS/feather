import Foundation
import Hummingbird

/// A typed, one-time message shown after an admin action completes.
public struct AdminNotification: Codable, Sendable, Equatable {
    public enum Kind: String, Codable, Sendable {
        case success
        case info
        case warning
        case error
    }

    public let kind: Kind
    public let title: String
    public let message: String
    public let position: String

    public init(
        kind: Kind = .success,
        title: String,
        message: String,
        position: String = "top-right"
    ) {
        self.kind = kind
        self.title = title
        self.message = message
        self.position = position
    }
}

/// Carries an admin notification across a POST redirect without query flags.
public enum AdminNotificationFlash {
    public static let cookieName = "admin_notification"

    public static func notification(from request: Request) -> AdminNotification? {
        guard
            let value = request.cookies[cookieName]?.value,
            let data = Data(base64Encoded: value)
        else { return nil }
        return try? JSONDecoder().decode(AdminNotification.self, from: data)
    }

    public static func cookie(for notification: AdminNotification) -> Cookie {
        let data = (try? JSONEncoder().encode(notification)) ?? Data()
        return Cookie(
            name: cookieName,
            value: data.base64EncodedString(),
            maxAge: 30,
            path: "/admin",
            httpOnly: false,
            sameSite: .lax
        )
    }

    public static func redirect(
        to location: String,
        notification: AdminNotification
    ) -> Response {
        var headers: HTTPFields = [.location: location]
        headers[values: .setCookie].append(cookie(for: notification).description)
        return Response(status: .seeOther, headers: headers)
    }
}
