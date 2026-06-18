//
//  File.swift
//  app-kernel
//
//  Created by Tibor Bödecs on 2026. 04. 16..
//

public protocol DTO: Sendable {}

extension Bool: DTO {}

extension Int: DTO {}
extension Int8: DTO {}
extension Int16: DTO {}
extension Int32: DTO {}
extension Int64: DTO {}
extension Int128: DTO {}

extension UInt: DTO {}
extension UInt8: DTO {}
extension UInt16: DTO {}
extension UInt32: DTO {}
extension UInt64: DTO {}
extension UInt128: DTO {}

extension Float: DTO {}
extension Double: DTO {}

extension String: DTO {}

extension Array: DTO {}
extension Dictionary: DTO {}
extension Set: DTO {}
