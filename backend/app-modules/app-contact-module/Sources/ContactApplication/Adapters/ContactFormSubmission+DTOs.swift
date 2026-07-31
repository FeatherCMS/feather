import ContactDomain

extension ContactFormSubmission {
    var asDetail: ContactFormSubmissionDetail {
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
