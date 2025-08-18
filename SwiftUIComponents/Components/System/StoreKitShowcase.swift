import SwiftUI
import StoreKit

struct StoreKitShowcase: View {
    let sampleProductIDs = ["com.example.premium", "com.example.subscription"]
    
    var body: some View {
        VStack(spacing: 0) {
            NativeStoreKitExample(
                title: "ProductView",
                description: "Native iOS 17+ ProductView for single product",
                style: .productView,
                productIDs: ["com.example.premium"]
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeStoreKitExample(
                title: "StoreView",
                description: "StoreView for multiple products with restore button",
                style: .storeView,
                productIDs: sampleProductIDs
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeStoreKitExample(
                title: "SubscriptionStoreView",
                description: "Native subscription store with policies",
                style: .subscriptionStoreView,
                productIDs: ["com.example.subscription"]
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeStoreKitExample(
                title: "Custom ProductView",
                description: "ProductView with custom icon and compact style",
                style: .customProductView,
                productIDs: ["com.example.premium"]
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeStoreKitStyle: CaseIterable {
    case productView
    case storeView
    case subscriptionStoreView
    case customProductView
    
    var displayName: String {
        switch self {
        case .productView: return "ProductView"
        case .storeView: return "StoreView"
        case .subscriptionStoreView: return "SubscriptionStore"
        case .customProductView: return "Custom Product"
        }
    }
}

struct NativeStoreKitExample: View {
    let title: String
    let description: String
    let style: NativeStoreKitStyle
    let productIDs: [String]
    @State private var showingSignIn = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // StoreKit examples (only available iOS 17+)
            if #available(iOS 17.0, *) {
                Group {
                    switch style {
                    case .productView:
                        if let productID = productIDs.first {
                            ProductView(id: productID)
                                .productViewStyle(.regular)
                                .frame(height: 80)
                        }
                        
                    case .storeView:
                        StoreView(ids: productIDs)
                            .productViewStyle(.compact)
                            .storeButton(.visible, for: .restorePurchases)
                            .frame(height: 120)
                        
                    case .subscriptionStoreView:
                        if let subscriptionID = productIDs.first {
                            SubscriptionStoreView(productIDs: [subscriptionID]) {
                                VStack {
                                    Text("Premium Features")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Text("Unlock all premium features with our subscription!")
                                        .multilineTextAlignment(.center)
                                        .font(.subheadline)
                                }
                                .foregroundStyle(.white)
                                .containerBackground(.blue.gradient, for: .subscriptionStore)
                            }
                            .storeButton(.visible, for: .restorePurchases, .redeemCode)
                            .subscriptionStorePolicyDestination(for: .privacyPolicy) {
                                Text("Privacy Policy Content")
                                    .padding()
                            }
                            .subscriptionStorePolicyDestination(for: .termsOfService) {
                                Text("Terms of Service Content")
                                    .padding()
                            }
                            .subscriptionStoreSignInAction {
                                showingSignIn = true
                            }
                            .frame(height: 200)
                        }
                        
                    case .customProductView:
                        if let productID = productIDs.first {
                            ProductView(id: productID) { _ in
                                Image(systemName: "crown.fill")
                                    .font(.title)
                                    .foregroundStyle(.yellow)
                            } placeholderIcon: {
                                ProgressView()
                                    .controlSize(.mini)
                            }
                            .productViewStyle(.compact)
                            .frame(height: 60)
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            } else {
                // Fallback for iOS 16
                VStack(spacing: 8) {
                    Image(systemName: "cart.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                    
                    Text("StoreKit Views")
                        .font(.headline)
                    
                    Text("Available in iOS 17+")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("Use legacy StoreKit APIs for iOS 16")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(height: 100)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: ""))")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                
                Text(storeKitDescription)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .sheet(isPresented: $showingSignIn) {
            NavigationView {
                VStack(spacing: 20) {
                    Text("Sign In")
                        .font(.title)
                    
                    Text("Sign in to your account to manage subscriptions")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            showingSignIn = false
                        }
                    }
                }
            }
        }
    }
    
    private var storeKitDescription: String {
        switch style {
        case .productView:
            return "ProductView(id: String)"
        case .storeView:
            return "StoreView(ids: [String]) + restore button"
        case .subscriptionStoreView:
            return "SubscriptionStoreView + policies"
        case .customProductView:
            return "ProductView with custom icon"
        }
    }
}

#Preview {
    ScrollView {
        StoreKitShowcase()
            .padding()
    }
} 