import UIKit

extension Decimal {
    var formattedWithCommaSeparator: String {
        return Formatter.withCommaSeparator.string(for: self) ?? ""
    }
}

extension Formatter {
    static let withCommaSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

struct TestObject: Codable {
    var priceDecimal: Decimal
    var priceDouble: Double
    var amount: Decimal
}

var myObjectData = "{\"priceDecimal\": 9159795.995, \"priceDouble\": 1.1, \"amount\": 1.7, \"cashPrice\":  4.1175}".data(using: .utf8)!


let testObject = try! JSONDecoder().decode(TestObject.self, from: myObjectData)

print(testObject.priceDecimal)
print(testObject.priceDouble)
print(testObject.amount)


// Example
// Double -> Decimal -> Formatted String
let double3 = Double(1000.0055)
let value3: Decimal = Decimal(floatLiteral: double3)
let stringValue3 = value3.formattedWithCommaSeparator
print(stringValue3) // 1,000.006


// Example
// String -> Decimal -> JSON
struct StringDecimalJSON: Codable {
    let priceDouble: Double
    let priceDecimal: Decimal
    let priceString: String
}

func userInputTest(input: String) -> String {

    // We must remove the commas
    let _input = input.replacingOccurrences(of: ",", with: "")
    
    // Convert user input string to Double
    let createdDouble = Double(_input)!
    
    // Convert user input field to Decimal
    let createdDecimal = Decimal(string: _input)!
    
    // Now let's serialize to JSON to send to server
    let priceStruct = StringDecimalJSON(priceDouble: createdDouble,
                                        priceDecimal: createdDecimal,
                                        priceString: _input)
    let json = try! JSONEncoder().encode(priceStruct)
    
    return String(data: json, encoding: .utf8) ?? "error"
}

func displayValuesFromServer(jsonString: String) -> String {
    let jsonData = jsonString.data(using: .utf8)!
    
    // Decode to object
    let object = try! JSONDecoder().decode(StringDecimalJSON.self, from: jsonData)
    
    return "\(object.priceDouble), \(object.priceDecimal), \(object.priceString)"
}




let exampleOne = "9,159,795.995"
let exampleOneResult = userInputTest(input: exampleOne)


let exampleTwo = "1000.0055"
let exampleTwoResult = userInputTest(input: exampleTwo)


let exampleThree = "0.3"
let exampleThreeResult = userInputTest(input: exampleThree)



// Server Values
let jsonExampleOne = """
{
    "priceDouble": 9159795.995,
    "priceDecimal": 9159795.995,
    "priceString": "9159795.995"
}
"""
let serverExampleOneResult = displayValuesFromServer(jsonString: jsonExampleOne)


let jsonExampleTwo = """
{
"priceDouble": 0.3,
"priceDecimal": 0.3,
"priceString": "0.3"
}
"""
let serverExampleTwoResult = displayValuesFromServer(jsonString: jsonExampleTwo)







