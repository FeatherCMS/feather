public import ContactModule
public import FeatherApplication

extension Form.Submit {
    public struct Input: DTO {
        public let formKey: String
        public let valuesJSON: String
        public let itemsSnapshotJSON: String
        public let metadataJSON: String?

        public init(
            formKey: String,
            valuesJSON: String,
            itemsSnapshotJSON: String,
            metadataJSON: String? = nil
        ) {
            self.formKey = formKey
            self.valuesJSON = valuesJSON
            self.itemsSnapshotJSON = itemsSnapshotJSON
            self.metadataJSON = metadataJSON
        }
    }
}
