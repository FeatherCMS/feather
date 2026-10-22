public import Foundation

public struct ContactAPIBuilder: Sendable {
    public let apiBaseURL: URL

    public init(apiBaseURL: URL) {
        self.apiBaseURL = apiBaseURL
    }
}
