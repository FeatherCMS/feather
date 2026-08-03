import ContactDomain

extension ContactFormMail {
    var asDetail: ContactFormMailDetail {
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
