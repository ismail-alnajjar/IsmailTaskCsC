import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskcsc/model/course_model.dart';
import 'package:taskcsc/services/course_sync_service.dart';

class PayPage extends StatefulWidget {
  final String? buttonTitle;
  final Course? course;

  const PayPage({super.key, this.buttonTitle, this.course});

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cardNumber = TextEditingController();
  final TextEditingController holderName = TextEditingController();
  final TextEditingController expiryDate = TextEditingController();
  final TextEditingController cvv = TextEditingController();

  bool _isLoading = false;

  /// ✅ إضافة الكورس لمجموعة المستخدم (إن وجد)
  Future<void> _addCourseToMyCourses() async {
    if (widget.course == null) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Please log in first.')),
        );
        return;
      }

      setState(() => _isLoading = true);

      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('myCourses')
          .doc(
            widget.course?.id?.toString() ??
                DateTime.now().millisecondsSinceEpoch.toString(),
          );

      await docRef.set({
        'courseId': widget.course?.id,
        'title': widget.course?.title ?? '',
        'teacherName': widget.course?.teacherName ?? 'Unknown',
        'price': widget.course?.price ?? 0,
        'description': widget.course?.description ?? '',
        'coverImage': widget.course?.coverImage ?? '',
        'purchasedAt': FieldValue.serverTimestamp(),
      });

      await CourseSyncService.saveCoursesToFirebase([widget.course!]);

      setState(() => _isLoading = false);

      _showSuccessDialog();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    }
  }

  /// 🟢 نافذة نجاح الدفع
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFF007C83),
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                "Payment Successful!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF007C83),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your course has been added 🎉",
                style: TextStyle(color: Colors.black54, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007C83),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🟣 تنفيذ الدفع
  Future<void> _handlePayment() async {
    if (_formKey.currentState?.validate() ?? false) {
      await _addCourseToMyCourses();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF8F6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Payment Method",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF007C83)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    const Text(
                      "Add Payment Method",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Provide your payment method details below",
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    const SizedBox(height: 28),

                    const Text(
                      "Payment Type",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/Visa.png',
                          height: size.height * 0.04,
                        ),
                        Image.asset(
                          'assets/Paypal.png',
                          height: size.height * 0.04,
                        ),
                        Image.asset(
                          'assets/googlePay.png',
                          height: size.height * 0.06,
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),

                    _inputField(
                      "Enter Card Number",
                      Icons.credit_card,
                      cardNumber,
                    ),
                    const SizedBox(height: 16),
                    _inputField(
                      "Enter Card Holder Name",
                      Icons.person,
                      holderName,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _inputField(
                            "Expiry Date",
                            Icons.date_range,
                            expiryDate,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _inputField(
                            "CVV",
                            Icons.lock,
                            cvv,
                            obscure: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 45),

                    GestureDetector(
                      onTap: _handlePayment,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF007C83), Color(0xFF0B3A54)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.buttonTitle ?? "Pay Now",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
    );
  }

  /// 📥 عنصر إدخال
  Widget _inputField(
    String hint,
    IconData icon,
    TextEditingController ctrl, {
    bool obscure = false,
  }) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      validator: (v) =>
          (v == null || v.isEmpty) ? "⚠️ Please fill out this field" : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black45, fontSize: 15),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
