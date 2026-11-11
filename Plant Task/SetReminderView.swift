//
//  SetReminderView.swift
//  Plant Task
//
//  Created by HANAN ABDALLAH on 01/06/1448 AH.
//

import SwiftUI

struct AddPlantView: View {
    // 1. متغيرات الحالة (State) لحفظ المدخلات التي يكتبها أو يختارها المستخدم
    @State private var plantName: String = ""
    @State private var selectedRoom: String = "Bedroom"
    @State private var selectedLight: String = "Full sun"
    @State private var wateringDays: String = "Every day"
    @State private var waterAmount: String = "20-50 ml"
    
    // خيارات القوائم المنسدلة
    let rooms = ["Bedroom", "Living Room", "Kitchen", "Balcony", "Bathroom"]
    let lights = ["Full sun", "Partial sun", "Low light"]
    let frequencies = ["Every day", "Every 2 days", "Every 3 days", "Once a week"]
    let amounts = ["20-50 ml", "50-100 ml", "100-200 ml"]

    var body: some View {
        // 2. استخدام NavigationView لإنشاء شريط التنقل العلوي (Navigation Bar)
        NavigationView {
            ZStack {
                // خلفية سوداء متناسقة مع التصميم العام
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    // 3. حقل إدخال اسم النبتة (Plant Name Text Field)
                    HStack {
                        Text("Plant Name")
                            .foregroundColor(.white)
                            .font(.subheadline)
                        
                        TextField("Pothos", text: $plantName)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    .padding()
                    .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    // 4. مجموعة خيارات الغرفة والإضاءة (Room & Light Pickers)
                    VStack(spacing: 0.5) { // الفاصل الصغير بين السطور
                        PickerRow(icon: "paperplane", title: "Room", selection: $selectedRoom, options: rooms)
                        Divider().background(Color.gray.opacity(0.3))
                        PickerRow(icon: "sun.max", title: "Light", selection: $selectedLight, options: lights)
                    }
                    .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    // 5. مجموعة خيارات أيام الري وكمية الماء (Watering Days & Water Amount)
                    VStack(spacing: 0.5) {
                        PickerRow(icon: "drop", title: "Watering Days", selection: $wateringDays, options: frequencies)
                        Divider().background(Color.gray.opacity(0.3))
                        PickerRow(icon: "drop.fill", title: "Water", selection: $waterAmount, options: amounts)
                    }
                    .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            // 6. تخصيص شريط التنقل العلوي (Navigation Bar Items)
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                // زر الإغلاق (X) في أقصى اليسار
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // كود إغلاق أو الرجوع للشاشة السابقة
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                
                // زر الصح (Checkmark) في أقصى اليمين للحفظ
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // كود حفظ بيانات النبتة الجديدة
                    }) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color(red: 0.2, green: 0.5, blue: 0.4))
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
}

// مكون مساعد (Helper View) لتصميم الصفوف التي تحتوي على قوائم منسدلة بشكل موحد واحترافي
struct PickerRow: View {
    var icon: String
    var title: String
    @Binding var selection: String
    var options: [String]

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            // عنصر Picker لتقديم قائمة منسدلة عصرية للمستخدم
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu)
            .accentColor(.gray)
        }
        .padding()
    }
}

#Preview {
    AddPlantView()
}
