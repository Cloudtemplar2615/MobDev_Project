**Features Implemented**

**Shopping List Core**
 
Add items with name, price, and category

Edit existing items via tap

Delete items with swipe or from the edit screen

"Start by adding your first item!" message if list is empty

Search bar to filter products by name

**Categories**

Predefined: Food, Medication, Cleaning, Other

Users can add and save custom categories

Items are grouped visually by category

Emoji icons for category clarity

** Tax Calculator**

Category-specific tax rates:

Food → 5%

Medication → 0%

Cleaning & Other → 13%

Displays:

Subtotal

Tax amount

Final total

Tap total to view full breakdown sheet

**Persistent Storage**

Uses UserDefaults to store:

Products

Categories

Last update timestamp

Implements Codable for safe encoding/decoding

**User Interface**

Tab-based navigation:

Shopping List

Pie Chart

About

Clean, modern UI

Fully supports Dark Mode

Responsive layout with iOS system design

**Analytics **

Visual Pie Chart of spending by category

Tap a category row to view:

Total spend

Full list of items in that category



**Technologies Used**

SwiftUI

Xcode

Charts (Swift Charts)

UserDefaults

Codable

**How to Run**

Clone the repo or download ZIP

Open the project in Xcode 14+

Build & run on iOS Simulator or real device (iOS 16+)
