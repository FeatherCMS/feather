public struct WebFormSubmissionFeedback: Sendable {
    public enum Source: String, Sendable {
        case contact
        case newsletter
    }

    public enum Status: String, Sendable {
        case success
        case failure
    }

    public static let sourceQueryKey = "formSubmissionSource"
    public static let keyQueryKey = "formSubmissionKey"
    public static let statusQueryKey = "formSubmissionStatus"

    public let source: Source
    public let key: String
    public let status: Status

    public init?(
        source: String?,
        key: String?,
        status: String?
    ) {
        guard
            let source = source.flatMap(Source.init(rawValue:)),
            let key,
            !key.isEmpty,
            let status = status.flatMap(Status.init(rawValue:))
        else {
            return nil
        }
        self.source = source
        self.key = key
        self.status = status
    }
}
