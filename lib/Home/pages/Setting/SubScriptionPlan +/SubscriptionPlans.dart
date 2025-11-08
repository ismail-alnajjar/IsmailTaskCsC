import 'package:flutter/material.dart';
import 'package:taskcsc/Home/pages/Setting/SubScriptionPlan%20+/PlanCard.dart';

class SubscriptionPlans extends StatelessWidget {
  const SubscriptionPlans({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF8F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Subscription Plans",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Choose The Right Plan For\nYour Learning Journey.",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 30),

              // 🔹 Basic Plan
              PlanCard(
                title: "Basic Plan",
                description: "Unlock Essential Courses\nAnd Features.",
                price: "\$9.99",
                duration: "Monthly",
                gradient: const LinearGradient(
                  colors: [Colors.white, Colors.white],
                ),
                isPremium: false,
              ),
              const SizedBox(height: 18),

              // 🔹 Pro Plan
              PlanCard(
                title: "Pro Plan",
                description: "Get Certificates And Offline\nAccess.",
                price: "\$9.99",
                duration: "Monthly",
                gradient: const LinearGradient(
                  colors: [Colors.white, Colors.white],
                ),
                isPremium: false,
              ),
              const SizedBox(height: 18),

              // 🔹 Premium Plan
              PlanCard(
                title: "Premium Plan",
                description: "Exclusive Content And VIP Support.",
                price: "\$9.99",
                duration: "Monthly",
                gradient: const LinearGradient(
                  colors: [Color(0xFF0E7C82), Color(0xFF004F56)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                isPremium: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////
/// 🟦 Widget للعناصر داخل Premium Plan
