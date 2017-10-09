
import Foundation

public extension Date {
	
	public static func ISOStringFromDate(date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
		
		return dateFormatter.string(from: date).appending("Z")
	}
	
	public static func dateFromISOString(string: String) -> Date {
		
		let ISOFormatter = ISO8601DateFormatter()
		ISOFormatter.timeZone = NSTimeZone.local
		
		if let result = ISOFormatter.date(from: string) {
			
			return result
			
		} else {
			
			let supportedFormats = ["yyyy-MM-dd'T'HH:mm:ss.SSS","yyyy-MM-dd'T'HH:mm:ss.SSSZ","yyyy-MM-dd","yyyy-MM-dd HH:mm:ssZ"]
			
			for format in supportedFormats {
				let dateFormatter = DateFormatter()
				dateFormatter.timeZone = NSTimeZone.local
				dateFormatter.dateFormat = format
				
				
				if let result = dateFormatter.date(from: string) {
					
					return result
					
				}
			}
			
			return Date.distantPast
		}
		
	}
}

enum GSAlertType : String {
	case stockBought = "stock_bought",
	stockSold = "stock_sold"
}

class GSAlert : Codable {
	
	var id: Int?
	var type: String?
	var userName: String?
	var date : Date?
	var symbol : String?
	var message : String?
	
	enum MyStructKeys : String, CodingKey {
		case id = "id", type = "type", userName = "user_name", date = "date", symbol = "symbol", message = "message"
	}
	
	func getType() -> GSAlertType {
		return GSAlertType(rawValue: self.type ?? "") ?? GSAlertType.stockBought
	}
	
	// extracting the data
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: MyStructKeys.self) // defining our (keyed) container
		let id : Int? = try? container.decode(Int.self, forKey: .id) // extracting the data
		let type : String? = try? container.decode(String.self, forKey: .type)
		let userName : String? = try? container.decode(String.self, forKey: .userName)
		let dateString : String? = try? container.decode(String.self, forKey: .date)
		let symbol : String? = try? container.decode(String.self, forKey: .symbol)
		let message : String? = try? container.decode(String.self, forKey: .message)
		
		
		self.id = id
		self.type = type
		self.userName = userName
		self.symbol = symbol
		self.message = message
        self.date = Date.dateFromISOString(string: dateString ?? "")
	}
}
