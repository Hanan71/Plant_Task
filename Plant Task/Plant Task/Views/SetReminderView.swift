//
//  SetReminderView.swift
//  Plant Task
//
//  Created by HANAN ABDALLAH on 01/06/1448 AH.
//

import SwiftUI

struct AddPlantView: View {
    @EnvironmentObject var viewModel: PlantViewModel
    @Environment(\.dismiss) private var dismiss

    // متغير يحدد هل هي إضافة جديدة (false) أم تعديل نبتة (true)
    var isEditing: Bool = false

    // جديد: النبتة المراد تعديلها (nil = إضافة جديدة)
    var plantToEdit: PlantItem? = nil

    @State private var plantName: String = ""
    @State private var selectedRoom: String = "Bedroom"
    @State private var selectedLight: String = "Full sun"
    @State private var wateringDays: String = "Every day"
    @State private var waterAmount: String = "20-50 ml"

    let rooms = ["Bedroom", "Living Room", "Kitchen", "Balcony", "Bathroom"]
    let lights = ["Full sun", "Partial sun", "Low light"]
    let frequencies = ["Every day", "Every 2 days", "Every 3 days", "Once a week"]
    let amounts = ["20-50 ml", "50-100 ml", "100-200 ml"]

    // جديد: نعبي الحقول ببيانات النبتة إذا كنا في وضع التعديل
    init(isEditing: Bool = false, plantToEdit: PlantItem? = nil) {
        self.isEditing = isEditing || plantToEdit != nil
        self.plantToEdit = plantToEdit
        _plantName = State(initialValue: plantToEdit?.name ?? "")
        _selectedRoom = State(initialValue: plantToEdit?.room ?? "Bedroom")
        _selectedLight = State(initialValue: plantToEdit?.light ?? "Full sun")
        _wateringDays = State(initialValue: plantToEdit?.frequency ?? "Every day")
        _waterAmount = State(initialValue: plantToEdit?.waterAmount ?? "20-50 ml")
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.1, green: 0.1, blue: 0.1)
                    .ignoresSafeArea()

                VStack(spacing: 20) {

                    // حقل إدخال اسم النبتة
                    HStack {
                        Text("Plant Name")
                            .foregroundColor(.white)
                            .font(.subheadline)

                        TextField("Pothos", text: $plantName)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    .padding()
                    .background(Color(red: 0.17, green: 0.17, blue: 0.17))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)

                    // خيارات الغرفة والإضاءة
                    VStack(spacing: 0.5) {
                        PickerRow(icon: "paperplane", title: "Room", selection: $selectedRoom, options: rooms)
                        Divider().background(Color.gray.opacity(0.3))
                        PickerRow(icon: "sun.max", title: "Light", selection: $selectedLight, options: lights)
                    }
                    .background(Color(red: 0.17, green: 0.17, blue: 0.17))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)

                    // خيارات أيام الري والماء
                    VStack(spacing: 0.5) {
                        PickerRow(icon: "drop", title: "Watering Days", selection: $wateringDays, options: frequencies)
                        Divider().background(Color.gray.opacity(0.3))
                        PickerRow(icon: "drop.fill", title: "Water", selection: $waterAmount, options: amounts)
                    }
                    .background(Color(red: 0.17, green: 0.17, blue: 0.17))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)

                    // زر الحذف يظهر فقط في وضع التعديل
                    if isEditing {
                        Button(action: {
                            // جديد: حذف النبتة فعلياً
                            if let plant = plantToEdit {
                                viewModel.deletePlant(id: plant.id)
                            }
                            dismiss()
                        }) {
                            Text("Delete Reminder")
                                .font(.headline)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.17, green: 0.17, blue: 0.17))
                                .cornerRadius(16)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }

                    Spacer()
                }
                .padding(.top, 20)
            }
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color(red: 0.1, green: 0.1, blue: 0.1), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                // زر الإغلاق (X)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // جديد: التحويل لـ NoReminders فقط عند الإضافة، مو التعديل
                        if !isEditing {
                            viewModel.skipToEmptyState()
                        }
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                    }
                }

                // زر الحفظ (Checkmark) - زر واحد فقط
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // جديد: إذا تعديل نحدّث النبتة، وإذا إضافة نضيفها
                        if let plant = plantToEdit {
                            viewModel.updatePlant(id: plant.id,
                                                  name: plantName,
                                                  room: selectedRoom,
                                                  light: selectedLight,
                                                  water: waterAmount,
                                                  frequency: wateringDays)
                        } else {
                            viewModel.addPlant(name: plantName,
                                               room: selectedRoom,
                                               light: selectedLight,
                                               water: waterAmount,
                                               frequency: wateringDays)
                            NotificationManager.shared.schedulePlantNotification(
                                plantName: plantName.isEmpty ? "plant" : plantName)
                        }
                        dismiss()
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
    AddPlantView(isEditing: false)
        .environmentObject(PlantViewModel())
}
