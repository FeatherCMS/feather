import ContactDomain

extension ContactFormItem {
    var asDetail: ContactFormItemDetail {
        .init(
            id: id,
            formId: formId,
            key: key,
            type: type,
            label: label,
            allowedValues: allowedValues,
            isRequired: isRequired,
            position: position,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
