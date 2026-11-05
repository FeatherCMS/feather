public import FeatherApplication
public import WebModule

extension Metadata.Resolve {
    public struct Input: DTO {
        public let referenceType: String
        public let referenceIDs: [String]

        public init(
            referenceType: String,
            referenceIDs: [String]
        ) {
            self.referenceType = referenceType
            self.referenceIDs = referenceIDs
        }
    }
}
