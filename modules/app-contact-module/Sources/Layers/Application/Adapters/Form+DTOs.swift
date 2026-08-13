import ContactDomain

extension Form {
    var asDetail: FormDetail {
        asDetail(fields: [], mails: [])
    }

    func asDetail(
        fields: [FormFieldDetail] = [],
        mails: [SubmissionMailDetail] = []
    ) -> FormDetail {
        .init(
            id: id,
            name: name,
            successMessage: successMessage,
            failureMessage: failureMessage,
            redirectUrl: redirectUrl,
            fields: fields,
            mails: mails,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
