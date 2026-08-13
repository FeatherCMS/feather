import FeatherApplication
import FeatherContracts
import Foundation

public struct AdminDashboardEventContext: ExecutionContext {
    public let apiBaseURL: URL
    public let sessionToken: String?
    public let permissions: Set<String>
    public let from: Double
    public let to: Double

    public init(
        apiBaseURL: URL,
        sessionToken: String?,
        permissions: Set<String>,
        from: Double,
        to: Double
    ) {
        self.apiBaseURL = apiBaseURL
        self.sessionToken = sessionToken
        self.permissions = permissions
        self.from = from
        self.to = to
    }
}
