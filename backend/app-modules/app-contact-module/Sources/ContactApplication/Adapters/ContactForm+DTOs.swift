import ContactDomain

extension ContactForm {
    var asDetail: ContactFormDetail {
        asDetail(items: [])
    }

    func asDetail(
        items: [ContactFormItemDetail] = []
    ) -> ContactFormDetail {
        .init(id: id, name: name, items: items, createdAt: createdAt, updatedAt: updatedAt)
    }
}
