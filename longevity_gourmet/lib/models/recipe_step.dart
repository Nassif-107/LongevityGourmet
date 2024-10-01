class RecipeStep {
  final int stepId;
  final int stepNumber;
  final String instructionText;
  final String imageUrl;

  RecipeStep({
    required this.stepId,
    required this.stepNumber,
    required this.instructionText,
    required this.imageUrl,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      stepId: json['step_id'],
      stepNumber: json['step_number'],
      instructionText: json['instruction_text'],
      imageUrl: json['image_url'] ?? '',
    );
  }
}
