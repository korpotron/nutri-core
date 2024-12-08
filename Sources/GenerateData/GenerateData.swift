import SwiftSyntax
import Foundation
import SwiftSyntaxBuilder
import Yams
import ArgumentParser

func generate(minerals: [String], output: String) {

    let xxx = SourceFileSyntax {
        """
        import NutriCore
        """

        CodeBlockItemListSyntax {
            try! ExtensionDeclSyntax("public extension Mineral") {
                minerals.map { mineral in
                    DeclSyntax("""
                static let \(raw: mineral) = Self("\(raw: mineral)")
                """)
                }
            }
        }

        CodeBlockItemListSyntax {
            try! ExtensionDeclSyntax("extension Mineral: CaseIterable") {
                try! VariableDeclSyntax("public static var allCases: Self.AllCases") {
                    ArrayExprSyntax {
                        ArrayElementListSyntax(expressions: minerals.map { mineral in
                            ExprSyntax(MemberAccessExprSyntax(name: .identifier(mineral)))
                        })
                    }
                }
            }
        }
    }

    var result = ""
    xxx.formatted().write(to: &result)
    print(result)

    try! result.write(toFile: output, atomically: true, encoding: .utf8)
    print("done")
}


@main
struct GenerateDataCommand: ParsableCommand {

    @Option(name: .customLong("input"), help: "Input file path.")
    var input: String

    @Option(name: .customLong("output"), help: "output file path.")
    var output: String

    mutating func run() throws {
        print("output: \(output)")
        print("input: \(input)")

        let data = try! String(contentsOf: URL(string: "file://" + input)!, encoding: .utf8).data(using: .utf8)!

        let decoder = YAMLDecoder()
        let minerals = try! decoder.decode([String].self, from: data)

        generate(minerals: minerals, output: output)
    }
}

private extension DeclModifierSyntax {
    static let `public` = DeclModifierSyntax(name: .keyword(.public))
}
