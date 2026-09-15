import Foundation

@available(*, deprecated, message: "Use AdminNotificationRedirect instead.")
public struct AdminStatusActionRedirect {
    public static func location(
        defaultPath: String,
        returnTo: String?,
        title: String,
        message: String
    ) -> String {
        AdminNotificationRedirect.location(
            defaultPath: defaultPath,
            returnTo: returnTo,
            title: title,
            message: message
        )
    }
}
