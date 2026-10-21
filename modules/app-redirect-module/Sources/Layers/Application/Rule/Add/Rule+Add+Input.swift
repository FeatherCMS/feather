public import FeatherApplication
public import RedirectModule

extension RedirectModule.Rule.Add {
    public struct Input: DTO {
        public let source: String
        public let destination: String
        public let statusCode: RedirectModule.Rule.StatusCode
        public let notes: String?

        public init(
            source: String,
            destination: String,
            statusCode: RedirectModule.Rule.StatusCode,
            notes: String?
        ) {
            self.source = source
            self.destination = destination
            self.statusCode = statusCode
            self.notes = notes
        }
    }
}
