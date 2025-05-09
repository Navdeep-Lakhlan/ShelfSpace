//
//  BorrowingSettingsView.swift
//  lms
//
//  Created by Diptayan Jash on 26/04/25.
//

import DotLottie
import Foundation
import SwiftUI

struct BorrowingSettingsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var policyViewModel: PolicyViewModel

    // State variables for borrowing settings
    @State private var maxBooksBorrowable: Double = 5
    @State private var reissuePeriodDays: Double = 14
    @State private var showingSaveAlert: Bool = false

    init(viewModel: PolicyViewModel? = nil) {
        if let vm = viewModel {
            _maxBooksBorrowable = State(initialValue: Double(vm.currentPolicy?.max_books_per_user ?? 5))
            _reissuePeriodDays = State(initialValue: Double(vm.currentPolicy?.max_borrow_days ?? 14))
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                ReusableBackground(colorScheme: colorScheme)
                VStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Cancel")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.red)
                        }
                        .accessibilityLabel("Cancel")
                        .accessibilityHint("Dismiss the borrowing settings screen")

                        Spacer()

                        Text("Borrowing Settings")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color.text(for: colorScheme))
                            .accessibilityAddTraits(.isHeader)

                        Spacer()

                        // Save button
                        Button(action: {
                            saveSettings()
                        }) {
                            Text("Save")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color.primary(for: colorScheme))
                        }
                        .disabled(policyViewModel.isLoading)
                        .accessibilityLabel("Save")
                        .accessibilityHint("Save your borrowing settings")
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 10)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 30) {
                            // Maximum Books Borrowable Card
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Maximum Books Borrowable")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color.text(for: colorScheme))
                                    .accessibilityAddTraits(.isHeader)

                                Text("\(Int(maxBooksBorrowable)) Books")
                                    .font(.system(size: 36, weight: .bold, design: .rounded))
                                    .foregroundColor(Color.primary(for: colorScheme))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 10)
                                    .accessibilityLabel("Selected maximum books borrowable")
                                    .accessibilityValue("\(Int(maxBooksBorrowable)) books")

                                // iOS-style slider
                                Slider(value: $maxBooksBorrowable, in: 1 ... 15, step: 1)
                                    .accentColor(Color.primary(for: colorScheme))
                                    .padding(.vertical, 10)
                                    .accessibilityLabel("Maximum number of books")
                                    .accessibilityValue("\(Int(maxBooksBorrowable))")
                                    .accessibilityHint("Adjust the number of books a user can borrow")

                                HStack {
                                    Text("1 Book")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.text(for: colorScheme).opacity(0.6))

                                    Spacer()

                                    Text("15 Books")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.text(for: colorScheme).opacity(0.6))
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(colorScheme == .dark ?
                                        Color(hex: ColorConstants.darkBackground).opacity(0.7) :
                                        Color.white.opacity(0.9))
                                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            )

                            // Reissue Period Card
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Reissue Period")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color.text(for: colorScheme))
                                    .accessibilityAddTraits(.isHeader)

                                Text("\(Int(reissuePeriodDays)) Days")
                                    .font(.system(size: 36, weight: .bold, design: .rounded))
                                    .foregroundColor(Color.primary(for: colorScheme))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 10)
                                    .accessibilityLabel("Selected reissue period")
                                    .accessibilityValue("\(Int(reissuePeriodDays)) days")

                                // iOS-style slider
                                Slider(value: $reissuePeriodDays, in: 1 ... 60, step: 1)
                                    .accentColor(Color.primary(for: colorScheme))
                                    .padding(.vertical, 10)
                                    .accessibilityLabel("Reissue period")
                                    .accessibilityValue("\(Int(reissuePeriodDays))")
                                    .accessibilityHint("Adjust the number of days allowed for reissue")

                                HStack {
                                    Text("1 Day")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.text(for: colorScheme).opacity(0.6))

                                    Spacer()

                                    Text("60 Days")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.text(for: colorScheme).opacity(0.6))
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(colorScheme == .dark ?
                                        Color(hex: ColorConstants.darkBackground).opacity(0.7) :
                                        Color.white.opacity(0.9))
                                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarHidden(true) // Hide the navigation bar completely
            .alert(isPresented: $showingSaveAlert) {
                if let error = policyViewModel.errorMessage {
                    return Alert(
                        title: Text("Error"),
                        message: Text(error),
                        dismissButton: .default(Text("OK"))
                    )
                } else {
                    return Alert(
                        title: Text("Success"),
                        message: Text("Borrow settings have been updated."),
                        dismissButton: .default(Text("OK")) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
            }
            .overlay(
                Group {
                    if policyViewModel.showAnimation {
                        DotLottieAnimation(
                            fileName: "policy",
                            config: AnimationConfig(
                                autoplay: true,
                                loop: true,
                                mode: .bounce,
                                speed: 1.5
                            )
                        )
                        .view()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.1))
                        .accessibilityHidden(true)
                    }
                }
            )
            .onAppear {
                if let policy = policyViewModel.currentPolicy {
                    maxBooksBorrowable = Double(policy.max_books_per_user)
                    reissuePeriodDays = Double(policy.max_borrow_days)
                }
            }
        }
    }

    // Save the settings using PolicyViewModel
    private func saveSettings() {
        if var updatedPolicy = policyViewModel.currentPolicy {
            updatedPolicy.max_books_per_user = Int(maxBooksBorrowable)
            updatedPolicy.max_borrow_days = Int(reissuePeriodDays)

            policyViewModel.savePolicy(policy: updatedPolicy) { success in
                if success {
                    showingSaveAlert = true
                }
            }
        }
    }
}
