import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../components/reactive_input_field.dart';
import '../../constant/data.dart';
import '../../constant/style.dart';
import '../../services/send_email.dart';
import '../../utils/open_link.dart';
import '../../widgets/section_header.dart';

class GetInTouchSection extends StatefulWidget {
  const GetInTouchSection({super.key});

  @override
  State<GetInTouchSection> createState() => _GetInTouchSectionState();
}

class _GetInTouchSectionState extends State<GetInTouchSection> {
  final contactForm = FormGroup({
    'name': FormControl<String>(
      value: '',
      validators: [Validators.required],
    ),
    'email': FormControl<String>(
      value: '',
      validators: [
        Validators.required,
        Validators.email,
        Validators.maxLength(62),
      ],
    ),
    'subject': FormControl<String>(
      value: '',
      validators: [Validators.required],
    ),
    'message': FormControl<String>(
      value: '',
      validators: [Validators.required],
    ),
  });

  bool _isSubmitting = false;

  @override
  void dispose() {
    contactForm.dispose();
    super.dispose();
  }

  Map<String, ValidationMessageFunction> _messages({bool email = false}) {
    return {
      ValidationMessage.required: (_) => 'This field is required',
      if (email) ValidationMessage.email: (_) => 'Enter a valid email',
      ValidationMessage.maxLength: (error) {
        final requiredLength = error is Map ? error['requiredLength'] : null;
        return 'Use fewer than $requiredLength characters';
      },
    };
  }

  String _value(String name) => '${contactForm.control(name).value ?? ''}';

  Future<void> _submit() async {
    if (_isSubmitting || contactForm.invalid) return;
    setState(() => _isSubmitting = true);
    try {
      final response = await sendEmail(
        _value('name'),
        _value('email'),
        _value('message'),
        _value('subject'),
      );
      if (!mounted) return;
      final sent = response.statusCode == 200;
      _showResult(
        sent
            ? "Thanks for your message. I'll take a look."
            : 'Something went wrong. Please try again.',
        sent,
      );
      if (sent) contactForm.reset();
    } catch (_) {
      if (!mounted) return;
      _showResult('Something went wrong. Please try again.', false);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showResult(String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? const Color(0xFF1AA742) : kColorRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: contactForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Get in touch'),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 640;
              final details = const _ContactDetails();
              final form = _MessageForm(
                messages: _messages,
                isSubmitting: _isSubmitting,
                onSubmit: _submit,
              );
              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    details,
                    const SizedBox(height: 20),
                    form,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  details,
                  const SizedBox(width: 28),
                  Expanded(child: form),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ContactDetails extends StatelessWidget {
  const _ContactDetails();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ContactLink(
          label: 'Phone',
          value: Data.phoneNumber,
          url: 'tel:${Data.phoneNumber}',
        ),
        const SizedBox(height: 16),
        _ContactLink(
          label: 'Email',
          value: Data.email,
          url: 'mailto:${Data.email}',
        ),
        const SizedBox(height: 16),
        Text('Location', style: kTextCaption),
        const SizedBox(height: 4),
        const Text(Data.location, style: kTextSub),
      ],
    );
  }
}

class _ContactLink extends StatelessWidget {
  const _ContactLink({
    required this.label,
    required this.value,
    required this.url,
  });

  final String label;
  final String value;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: kTextCaption),
        const SizedBox(height: 4),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => openLink(url),
            child: Text(
              value,
              style: kTextSub2.copyWith(color: kColorBlue),
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageForm extends StatelessWidget {
  const _MessageForm({
    required this.messages,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final Map<String, ValidationMessageFunction> Function({bool email}) messages;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReactiveInputField(
          formControlName: 'name',
          title: 'Your name',
          validationMessages: messages(),
        ),
        const SizedBox(height: 14),
        ReactiveInputField(
          formControlName: 'email',
          title: 'Your email',
          validationMessages: messages(email: true),
        ),
        const SizedBox(height: 14),
        ReactiveInputField(
          formControlName: 'subject',
          title: 'Subject',
          validationMessages: messages(),
        ),
        const SizedBox(height: 14),
        ReactiveInputField(
          formControlName: 'message',
          title: 'Message',
          maxLines: 4,
          validationMessages: messages(),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: ReactiveFormConsumer(
            builder: (context, form, child) {
              final canSend = form.valid && !isSubmitting;
              return FilledButton(
                onPressed: canSend ? onSubmit : null,
                child: Text(isSubmitting ? 'Sending...' : 'Send message'),
              );
            },
          ),
        ),
      ],
    );
  }
}
