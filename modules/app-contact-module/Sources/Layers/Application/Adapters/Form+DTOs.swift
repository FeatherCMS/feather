import ContactDomain

extension Form {
    var asDetail: Form.Detail.Output {
        asDetail(fields: [], mails: [])
    }

    func asDetail(
        fields: [FormField.Detail.Output] = [],
        mails: [SubmissionMail.Detail.Output] = []
    ) -> Form.Detail.Output {
        .init(
            id: id,
            key: key,
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
