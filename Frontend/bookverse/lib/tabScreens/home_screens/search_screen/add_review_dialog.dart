import 'package:bookverse/custom_ui/custom_text_field.dart';
import 'package:bookverse/custom_ui/custom_textfield.dart';
import 'package:bookverse/validation/validation.dart';
import 'package:flutter/material.dart';

class AddReviewDialog extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController contentController;
  final bool isContentValid;
  final int rating;
  final Function(String) updateContentValidation;
  final Function(int) updateRating;
  final VoidCallback onSubmit;

  const AddReviewDialog({
    super.key,
    required this.formKey,
    required this.contentController,
    required this.isContentValid,
    required this.rating,
    required this.updateContentValidation,
    required this.updateRating,
    required this.onSubmit,
  });

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  late int currentRating;

  @override
  void initState() {
    super.initState();
    currentRating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add Review', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 30),

              CustomTextField(
                controller: widget.contentController,  
                labelText: 'Write review',
                hintText: '',
                prefixIcon: Icon(Icons.rate_review_rounded),
                validator: (val) => validateField(val, 'Review', minLength: 5),
                onSaved: (val) => widget.contentController.text = val?.trim() ?? '',
                maxLines: 10,
              ),
              const SizedBox(height: 20),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Choose Rating:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    final starIndex = index + 1;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentRating = starIndex;
                        });
                        widget.updateRating(starIndex);
                      },
                      child: Icon(
                        Icons.star,
                        color: currentRating >= starIndex ? Colors.amber : Colors.grey[400],
                        size: 24,
                      ),
                    );
                  }),
                ),
              ],
            ),

            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                label: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              TextButton.icon(
                onPressed: widget.onSubmit,
                icon: const Icon(Icons.check_circle, size: 16, color: Colors.black87),
                label: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],

    );
  }
}
