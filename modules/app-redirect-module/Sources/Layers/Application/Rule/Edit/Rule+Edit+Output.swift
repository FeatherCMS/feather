public import FeatherApplication
public import RedirectModule

extension Rule.Edit {
    public struct Output: DTO {
        public let id: String
        public let source: String
        public let destination: String
        public let statusCode: Rule.StatusCode
        public let notes: String?

        package init(
            id: String,
            source: String,
            destination: String,
            statusCode: Rule.StatusCode,
            notes: String?
        ) {
            self.id = id
            self.source = source
            self.destination = destination
            self.statusCode = statusCode
            self.notes = notes
        }
    }
}
