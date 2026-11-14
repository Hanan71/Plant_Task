//
//  AllDoneView.swift
//  Plant Task
//

import SwiftUI

struct AllDoneView: View {
    @State private var showingAddPlant = false

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            // المحتوى في نص الشاشة بالضبط
            VStack(spacing: 20) {
                ZStack {
                    // شكل البقعة المتحرك (خلف الصورة)
                    RippleView()
                        .frame(width: 320, height: 320)

                    Image("plant_placeholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                }
                .frame(width: 320, height: 320)

                VStack(spacing: 6) {
                    Text("All Done! 🎉")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("All Reminders Completed")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            // العنوان فوق
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

                Spacer()
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
            AddPlantView()
        }
    }
}

// شكل واحد كبير يتحرك ببطء خلف الصورة
struct RippleView: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate

            BlobShape(phase: t * 0.6)
                .fill(Color.white.opacity(0.03))
            
                .scaleEffect(1.0 + 0.04 * sin(t * 0.9))
                .rotationEffect(.degrees(t * 6))
        }
    }
}

// شكل عضوي تتغير حوافه مع الوقت
struct BlobShape: Shape {
    var phase: Double

    var animatableData: Double {
        get { phase }
        set { phase = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let baseRadius = min(rect.width, rect.height) / 2 * 0.95
        let points = 8
        var coords: [CGPoint] = []

        for i in 0..<points {
            let angle = Double(i) / Double(points) * 2 * .pi
            // كل نقطة تتحرك بنسبة مختلفة عشان الحواف ما تتكرر
            let wobble = 0.12 * sin(phase + Double(i) * 1.7)
                       + 0.06 * cos(phase * 1.3 + Double(i) * 2.3)
            let r = baseRadius * (1 + wobble)
            coords.append(CGPoint(x: center.x + CGFloat(cos(angle) * r),
                                  y: center.y + CGFloat(sin(angle) * r)))
        }

        // نوصل النقاط بمنحنيات ناعمة
        var path = Path()
        let n = coords.count
        path.move(to: mid(coords[0], coords[n - 1]))
        for i in 0..<n {
            let current = coords[i]
            let next = coords[(i + 1) % n]
            path.addQuadCurve(to: mid(current, next), control: current)
        }
        path.closeSubpath()
        return path
    }

    private func mid(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
        CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
    }
}

#Preview {
    AllDoneView()
        .environmentObject(PlantViewModel())
}
