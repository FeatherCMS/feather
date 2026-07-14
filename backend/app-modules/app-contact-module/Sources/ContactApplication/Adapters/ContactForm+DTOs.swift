import ContactDomain

extension ContactForm {
    var asDetail: ContactFormDetail {
        asDetail(items: [], mails: [])
    }

    func asDetail(
        items: [ContactFormItemDetail] = [],
        mails: [ContactFormMailDetail] = []
    ) -> ContactFormDetail {
        .init(id: id, name: name, successMessage: successMessage, failureMessage: failureMessage, redirectUrl: redirectUrl, items: items, mails: mails, createdAt: createdAt, updatedAt: updatedAt)
    }
}
