import SwiftUI

struct Task: Identifiable{
    let id = UUID()
    let title: String
    let details: String
    let color: Color
}
