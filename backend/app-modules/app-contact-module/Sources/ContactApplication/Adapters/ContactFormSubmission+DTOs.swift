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
            submittedAt: submittedAt,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
