import ContactDomain

extension ContactForm {
    var asDetail: ContactFormDetail {
        .init(id: id, name: name, createdAt: createdAt, updatedAt: updatedAt)
    }
}
