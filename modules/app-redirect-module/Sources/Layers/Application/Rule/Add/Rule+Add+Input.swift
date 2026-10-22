public import FeatherApplication
public import RedirectModule

extension Rule.Add {
    public struct Input: DTO {
        public let source: String
        public let destination: String
        public let statusCode: Rule.StatusCode
        public let notes: String?

        public init(
            source: String,
            destination: String,
            statusCode: Rule.StatusCode,
            notes: String?
        ) {
            self.source = source
            self.destination = destination
            self.statusCode = statusCode
            self.notes = notes
        }
    }
}
