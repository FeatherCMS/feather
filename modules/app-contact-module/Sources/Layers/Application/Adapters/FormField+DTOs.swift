import ContactDomain
import ContactModule

extension FormField.Model {
    var asDetail: FormField.Detail.Output {
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
