//
//  TodayReminderView.swift
//  Plant Task
//
//  Created by HANAN ABDALLAH on 01/06/1448 AH.
//

import SwiftUI

// جديد: يخلينا نكتب الألوان بكود الـ Hex مباشرة (مثل Color(hex: "28E0A8"))
extension Color {
    init(hex: String) {
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

struct TodayReminderView: View {
    // ربط الواجهة بالـ ViewModel المشترك
    @EnvironmentObject var viewModel: PlantViewModel

    @State private var showingAddPlant = false

    // النبتة اللي انضغط عليها للتعديل (nil = ما فيه شاشة مفتوحة)
    @State private var plantToEdit: PlantItem?

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                Text("My Plants 🌱")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                Divider()
                    .background(Color.gray.opacity(0.3))
                    .padding(.top, 15)

                VStack(alignment: .leading, spacing: 10) {
                    Text(viewModel.wateredCount == 0 ? "Your plants are waiting for a sip 💦" : "\(viewModel.wateredCount) of your plants feel loved today ✨")
                        .font(.subheadline)
                        .foregroundColor(.white)

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(height: 6)
                                .cornerRadius(3)

                            Rectangle()
                                // جديد: أخضر الشريط 28E0A8
                                .fill(Color(hex: "28E0A8"))
                                .frame(width: geometry.size.width * viewModel.progressRatio, height: 6)
                                .cornerRadius(3)
                                .animation(.easeInOut, value: viewModel.progressRatio)
                        }
                    }
                    .frame(height: 6)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)

                // List لدعم السحب للحذف
                List {
                    ForEach($viewModel.plants) { $plant in
                        // الضغط على الأزرار الصغيرة (الإضاءة / الماء) يفتح التعديل
                        PlantRowView(plant: $plant, onChipTap: {
                            plantToEdit = plant
                        })
                            .contentShape(Rectangle())          // عشان الضغط يشتغل على كل الصف
                            .onTapGesture {                     // الضغط على النبتة يفتح التعديل
                                plantToEdit = plant
                            }
                            .listRowBackground(Color.black)
                            // لون الخط الرمادي 989898 بشفافية خفيفة
                            .listRowSeparatorTint(Color(hex: "989898").opacity(0.3))
                            // يخلي الخط الرمادي طويل من أول الصف لآخره
                            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                            .alignmentGuide(.listRowSeparatorTrailing) { d in d.width }
                    }
                    .onDelete(perform: viewModel.deletePlant)
                }
                .listStyle(.plain)
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showingAddPlant = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color(red: 0.2, green: 0.5, blue: 0.4))
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 30)
                }
            }
        }
        .sheet(isPresented: $showingAddPlant) {
            AddPlantView(isEditing: false)
        }
        // شاشة التعديل / الحذف
        .sheet(item: $plantToEdit) { plant in
            AddPlantView(plantToEdit: plant)
        }
    }
}

struct PlantRowView: View {
    @Binding var plant: PlantItem

    // يتنفذ لما تنضغط الأزرار الصغيرة (القيمة الافتراضية ما تسوي شي)
    var onChipTap: () -> Void = {}

    // جديد: ألوان الأزرار حسب التصميم
    private let sunColor = Color(hex: "CCC785")     // أصفر
    private let waterColor = Color(hex: "CAF3FB")   // سماوي

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Button(action: {
                plant.isWatered.toggle()
            }) {
                Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    // جديد: أخضر علامة الصح 28E0A8
                    .foregroundColor(plant.isWatered ? Color(hex: "28E0A8") : .gray)
            }
            .buttonStyle(.borderless)
            .padding(.top, 4)

            VStack(alignment: .leading, spacing: 6) {
                // هنا مكانها الصحيح
                Text("in \(plant.room)")
                    .font(.caption)
                    .foregroundColor(.gray)

                Text(plant.name)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)

                HStack(spacing: 10) {
                    // الشمس صفراء، والحدود تطلع بس لما يمر الماوس
                    Button(action: onChipTap) {
                        ChipLabel(icon: "sun.max", text: plant.light, color: sunColor)
                    }
                    .buttonStyle(ChipButtonStyle(borderColor: sunColor))

                    // الماء سماوي، والحدود تطلع بس لما يمر الماوس
                    Button(action: onChipTap) {
                        ChipLabel(icon: "drop", text: plant.waterAmount, color: waterColor)
                    }
                    .buttonStyle(ChipButtonStyle(borderColor: waterColor))
                }
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }
}

// شكل الزر الصغير
struct ChipLabel: View {
    var icon: String
    var text: String
    // لون الأيقونة والنص
    var color: Color = Color(red: 0.75, green: 0.75, blue: 0.75)

    var body: some View {
        // جديد: قربنا الكتابة من الأيقونة (كان 20 وصار 6)
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.caption)
        .foregroundColor(color)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(red: 0.17, green: 0.17, blue: 0.17))
        .cornerRadius(8)
    }
}

// الحدود تظهر فقط لما يمر المؤشر (ماوس / تراك باد)، وتختفي بدون مرور
struct ChipButtonStyle: ButtonStyle {
    var borderColor: Color = Color(red: 0.2, green: 0.7, blue: 0.5)

    func makeBody(configuration: Configuration) -> some View {
        ChipHoverView(configuration: configuration, borderColor: borderColor)
    }

    private struct ChipHoverView: View {
        let configuration: Configuration
        let borderColor: Color
        @State private var isHovering = false

        var body: some View {
            configuration.label
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isHovering ? borderColor : Color.clear, lineWidth: 1.5)
                )
                .animation(.easeInOut(duration: 0.15), value: isHovering)
                .onHover { isHovering = $0 }
        }
    }
}

#Preview {
    let vm = PlantViewModel()
    vm.addPlant(name: "Monstera", room: "Kitchen", light: "Full sun",
                water: "20-50 ml", frequency: "Every day")
    return TodayReminderView()
        .environmentObject(vm)
}
