import HTML
import SGML

public protocol ColumnWidthAttributeModifier:
    StyleAttributeModifier
where StyleAttributeValueType == String {}

extension ColumnWidthAttributeModifier where Self: Attributes & Mutable {

    public func columnWidth(
        percent: Int
    ) -> Self {
        style("width: \(percent)%")
    }
}

extension Th: ColumnWidthAttributeModifier {}

extension Td: ColumnWidthAttributeModifier {}
