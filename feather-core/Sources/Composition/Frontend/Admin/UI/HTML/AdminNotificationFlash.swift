import Foundation
import Hummingbird

/// Carries an admin notification across a POST redirect without query flags.
public enum AdminNotificationFlash {
    public static let cookieName = "admin_notification"

    public static func notification(
        from request: Request
    ) -> NewAdminNotification.State? {
        guard
            let value = request.cookies[cookieName]?.value,
            let data = Data(base64Encoded: value)
        else { return nil }
        return try? JSONDecoder()
            .decode(NewAdminNotification.State.self, from: data)
    }

    public static func cookie(
        for notification: NewAdminNotification.State
    ) -> Cookie {
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

    public static func clearCookie() -> Cookie {
        Cookie(
            name: cookieName,
            value: "",
            maxAge: 0,
            path: "/admin",
            httpOnly: false,
            sameSite: .lax
        )
    }

    public static func redirect(
        to location: String,
        notification: NewAdminNotification.State
    ) -> Response {
        var headers: HTTPFields = [.location: location]
        headers[values: .setCookie]
            .append(cookie(for: notification).description)
        return Response(status: .seeOther, headers: headers)
    }
}
