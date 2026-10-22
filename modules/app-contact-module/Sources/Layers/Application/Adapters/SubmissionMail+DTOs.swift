import ContactDomain

extension SubmissionMail {
    var asDetail: SubmissionMail.Detail.Output {
        .init(
            id: id,
            formId: formId,
            mailFrom: mailFrom,
            mailTo: mailTo,
            subject: subject,
            additionalHeaders: additionalHeaders,
            messageBody: messageBody,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
