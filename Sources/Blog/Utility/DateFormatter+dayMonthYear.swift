import Foundation

extension DateFormatter {
    static let dayMonthYear: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter
    }()
}
