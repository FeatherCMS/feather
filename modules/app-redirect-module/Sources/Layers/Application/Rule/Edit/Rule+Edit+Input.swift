public import FeatherApplication
public import FeatherDomain
public import RedirectDomain
public import RedirectModule

extension Rule.Edit {
    public struct Input: DTO {
        public let id: String
        public let source: FieldChange<String>
        public let destination: FieldChange<String>
        public let statusCode: FieldChange<Rule.Model.StatusCode>
        public let notes: OptionalFieldChange<String>

        public init(
            id: String,
            source: FieldChange<String> = .unchanged,
            destination: FieldChange<String> = .unchanged,
            statusCode: FieldChange<Rule.Model.StatusCode> = .unchanged,
            notes: OptionalFieldChange<String> = .unchanged
        ) {
            self.id = id
            self.source = source
            self.destination = destination
            self.statusCode = statusCode
            self.notes = notes
        }
    }
}
