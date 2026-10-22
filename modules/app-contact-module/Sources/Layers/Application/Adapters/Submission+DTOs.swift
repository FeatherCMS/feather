import ContactDomain
import ContactModule

extension Submission.Model {
    var asDetail: Submission.Detail.Output {
        .init(
            id: id,
            formId: formId,
            valuesJSON: valuesJSON,
            itemsSnapshotJSON: itemsSnapshotJSON,
            metadataJSON: metadataJSON,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
