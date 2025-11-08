import 'package:flutter/material.dart';
import 'package:taskcsc/Home/pages/PayPage.dart';
import 'package:taskcsc/Home/pages/Setting/SubScriptionPlan%20+/BenefitItem.dart';
import 'package:taskcsc/model/course_model.dart';

///////////////////////////////////////////////////////
/// 🟩 Widget خاص بالكارت الواحد (الخطة)
class PlanCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String duration;
  final LinearGradient gradient;
  final bool isPremium;

  const PlanCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.gradient,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 العنوان والسعر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isPremium ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      color: isPremium ? Colors.white : const Color(0xFF007C83),
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    duration,
                    style: TextStyle(
                      color: isPremium ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 5),

          // 🔹 الوصف
          Text(
            description,
            style: TextStyle(
              color: isPremium ? Colors.white70 : Colors.black54,
              fontSize: 13.5,
            ),
          ),

          if (isPremium) ...[
            const SizedBox(height: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                BenefitItem("Access To All Courses"),
                BenefitItem("Certification On Completion"),
                BenefitItem("Offline Access"),
                BenefitItem("Premium Support"),
                BenefitItem("Access To Exclusive Content"),
              ],
            ),
            const SizedBox(height: 16),

            // 🔹 زر الاشتراك
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // ✅ تمرير كورس وهمي لأن الخطة ليست كورس فعلي
                  final fakeCourse = Course(
                    id: 99,
                    title: "Premium Subscription Plan",
                    price: 29.99,
                    teacherName: "System",
                    description:
                        "Enjoy full access to all premium courses and exclusive content.",
                    coverImage: "",
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PayPage(
                        buttonTitle: "Subscribe Now",
                        course: fakeCourse,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF007C83),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Subscribe Now",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
