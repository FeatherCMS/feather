import ContactDomain

extension FormField {
    var asDetail: FormFieldDetail {
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
